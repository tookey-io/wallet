use std::collections::HashMap;
use std::fmt::{Display, Formatter};
use std::ops::Deref;
use std::pin::Pin;
use std::sync::atomic::AtomicU32;
use std::sync::{Mutex, RwLock};
use std::time::Duration;

use crate::global;
use crate::logger::{initialize_logger, log};
use anyhow::{anyhow, Context, Error, Result};
use curv::arithmetic::Converter;
use curv::elliptic::curves::Secp256k1;
use curv::BigInt;
use flutter_rust_bridge::{support, StreamSink};
use futures::channel::mpsc::Sender;
use futures::channel::mpsc::{channel, Receiver};
use futures::{Future, StreamExt, TryFutureExt};
use round_based::{AsyncProtocol, Msg};
use serde::{Deserialize, Serialize};
use tokio::runtime::Runtime;
use tss::ecdsa::state_machine::keygen::{Keygen, LocalKey, ProtocolMessage};
use tss::ecdsa::state_machine::sign::{OfflineProtocolMessage, PartialSignature};
use tss_ceremonies::ecdsa;

use hex::ToHex;

#[repr(C)]
#[derive(Debug, Serialize, Deserialize)]
pub enum ErrCode {
    Internal = 500,
    InvalidMessage = 502,
    Critical = 100,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum OutgoingMessage {
    Start,
    Ready,
    Issue { code: ErrCode, message: String },
    Communication { packet: String },
    Result { encoded: String },
    Close,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum IncomingMessage {
    Begin {
        scenario: TookeyScenarios,
    },
    Participant {
        index: u16,
        party: Option<u16>,
    },
    Group {
        indexes: Vec<u16>,
        parties: Vec<u16>,
    },
    Communication {
        packet: String,
    },
    Close,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum TookeyScenarios {
    KeygenECDSA {
        index: u16,
        parties: u16,
        threashold: u16,
    },
    SignECDSA {
        parties: Vec<u16>,
        key: String,
        hash: String,
    },
}

impl Display for ErrCode {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                ErrCode::Internal => "Internal",
                ErrCode::InvalidMessage => "InvalidMessage",
                ErrCode::Critical => "Critical",
            }
        )
    }
}
impl OutgoingMessage {
    pub fn critical(message: String) -> OutgoingMessage {
        OutgoingMessage::Issue {
            code: ErrCode::Critical,
            message,
        }
    }

    pub fn invalid(message: String) -> OutgoingMessage {
        OutgoingMessage::Issue {
            code: ErrCode::InvalidMessage,
            message,
        }
    }
}
impl Display for TookeyScenarios {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                TookeyScenarios::KeygenECDSA {
                    index: _,
                    parties: _,
                    threashold: _,
                } => "KeygenECDSA",
                TookeyScenarios::SignECDSA {
                    parties: _,
                    key: _,
                    hash: _,
                } => "SignECDSA",
            }
        )
    }
}
impl Display for OutgoingMessage {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                OutgoingMessage::Start => format!("Start"),
                OutgoingMessage::Ready => format!("Ready"),
                OutgoingMessage::Issue { code, message } => format!("Issue({}, {})", code, message),
                OutgoingMessage::Communication { packet: _ } => format!("Communication"),
                OutgoingMessage::Result { encoded: _ } => format!("Result"),
                OutgoingMessage::Close => format!("Close"),
            }
        )
    }
}

impl Display for IncomingMessage {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                IncomingMessage::Begin { scenario } => {
                    format!("Incoming(Begin({}))", scenario)
                }
                IncomingMessage::Participant { index, party } => {
                    format!("Incoming(Participant {} {:?})", index, party)
                }
                IncomingMessage::Group { indexes, parties } => format!(
                    "Incoming(Group(size: {}, parties: {:?}))",
                    indexes.len(),
                    parties
                ),
                IncomingMessage::Communication { packet: _ } =>
                    "Incoming(Communication)".to_owned(),
                IncomingMessage::Close => "Close".to_owned(),
            }
        )
    }
}

pub fn to_public_key(key: String, compressed: bool) -> Result<String> {
    let local_share: LocalKey<Secp256k1> =
        serde_json::from_str(key.as_str()).context("key deserialization")?;
    let pk = local_share.public_key();

    Ok(pk.to_bytes(true).deref().encode_hex())
}

pub fn to_ethereum_address(key: String) -> Result<String> {
    let local_share: LocalKey<Secp256k1> =
        serde_json::from_str(key.as_str()).context("key deserialization")?;
    let pk = local_share.y_sum_s;

    Ok(tookey_adapter_ethereum::to_address_checksum(pk))
}

pub fn message_to_hash(message: String) -> Result<String> {
    if !message.starts_with("0x") {
        return Err(anyhow!(
            "Incorrect token address (address must starts with 0x)"
        ));
    }

    let bytes = hex::decode(&message.as_str()[2..]).context("decode hex string")?;
    Ok(format!(
        "{:#x}",
        tookey_adapter_ethereum::message_hash(bytes)
    ))
}

pub fn to_ethereum_signature(message: String, signature: String, chain: u32) -> Result<String> {
    let hash = tookey_adapter_ethereum::message_hash(message.as_bytes());
    let mut signature: tookey_adapter_ethereum::SignatureRecid =
        serde_json::from_str(signature.as_str()).context("signature deserialization")?;

    let signature = tookey_adapter_ethereum::to_ethereum_signature(hash, &mut signature, chain)?;
    Ok(format!("{:#x}", signature))
}

async fn execute_keygen(
    id: u32,
    receiver: Receiver<IncomingMessage>,
    index: u16,
    participants: u16,
    threshold: u16,
) -> Result<String> {
    let incoming = receiver.filter_map(|msg| async move {
        match msg {
            IncomingMessage::Communication { packet } => {
                match serde_json::from_str::<Msg<ProtocolMessage>>(packet.as_str()) {
                    Ok(message) => Some(Ok(message)),
                    _ => Some(Err(anyhow!("Invalid incoming..."))),
                }
            }

            IncomingMessage::Close => None,
            _ => {
                log(format!("received unexped msg {}", msg)).unwrap();
                None
            }
        }
    });

    let outgoing = futures::sink::unfold(id, |id, msg| async move {
        let packet = serde_json::to_string(&msg).context("packet serialization")?;
        global::send_outgoin(id, OutgoingMessage::Communication { packet })?;
        Ok::<_, anyhow::Error>(id)
    });

    let incoming = incoming.fuse();
    tokio::pin!(incoming);
    tokio::pin!(outgoing);

    let keygen = Keygen::new(index, threshold, participants)?;

    let mut protocol = AsyncProtocol::new(keygen, incoming, outgoing);

    protocol
        .run()
        .map_err(|e| anyhow!("failed keygen ceremony: {}", e))
        .await
        .and_then(|sig| serde_json::to_string(&sig).context("signature serialization"))
}

async fn execute_sign(
    id: u32,
    receiver: Receiver<IncomingMessage>,
    parties: Vec<u16>,
    key: String,
    hash: String,
) -> Result<String> {
    let incoming = receiver.filter_map(|msg| async move {
        match msg {
            // IncomingMessage::Begin { scenario } => todo!(),
            // IncomingMessage::Participant { index, party } => todo!(),
            // IncomingMessage::Group { indexes, parties } => todo!(),
            IncomingMessage::Communication { packet } => {
                let possible_offline =
                    serde_json::from_str::<Msg<OfflineProtocolMessage>>(packet.as_str());
                let possible_partial =
                    serde_json::from_str::<Msg<PartialSignature>>(packet.as_str());

                match (possible_offline, possible_partial) {
                    (Ok(offline), _) => {
                        log(format!("[{}] received offline {:?}", id, offline)).unwrap();
                        Some(Ok(ecdsa::Messages::OfflineStage(offline)))
                    }
                    (_, Ok(partial)) => {
                        log(format!("[{}] received partial {:?}", id, partial)).unwrap();
                        Some(Ok(ecdsa::Messages::PartialSignature(partial)))
                    }
                    _ => Some(Err(anyhow!("Invalid incoming.. not ecdsa message"))),
                }
            }
            IncomingMessage::Close => None,
            _ => {
                log(format!("[{}] received unexped msg {}", id, msg)).unwrap();
                None
            }
        }
    });

    let outgoing_sender = futures::sink::unfold(0, |_, msg| async move {
        let packet = match msg {
            ecdsa::Messages::OfflineStage(msg) => serde_json::to_string(&msg),
            ecdsa::Messages::PartialSignature(msg) => serde_json::to_string(&msg),
        }
        .context("packet serialization")?;
        global::send_outgoin(id, OutgoingMessage::Communication { packet })?;
        Ok::<_, anyhow::Error>(0)
    });

    let local_share = serde_json::from_str(key.as_str())?;

    let hash = tookey_adapter_ethereum::hash_to_bytes(hash)?;

    ecdsa::sign(
        outgoing_sender,
        incoming,
        local_share,
        parties,
        BigInt::from_bytes(hash.as_bytes()),
    )
    .map_err(|e| anyhow!("failed signature ceremony: {}", e))
    .await
    .and_then(|sig| serde_json::to_string(&sig).context("signature serialization"))
}

async fn execution_loop(id: u32, mut receiver: Receiver<IncomingMessage>) -> Result<String> {
    global::send_outgoin(id, OutgoingMessage::Ready)?;

    let mut step = 0;
    loop {
        step += 1;
        log(format!("[{}] Loop step {}", id, step))?;

        match receiver.next().await {
            Some(IncomingMessage::Begin { scenario }) => match scenario {
                TookeyScenarios::KeygenECDSA {
                    index,
                    parties,
                    threashold,
                } => {
                    log(format!(
                        "[{}] Begin ecdsa keygen of {} of {}",
                        id,
                        threashold + 1,
                        parties
                    ))?;
                    return execute_keygen(id, receiver, index, parties, threashold).await;
                }
                TookeyScenarios::SignECDSA { key, parties, hash } => {
                    log(format!("[{}] Begin ecdsa sign of {}", id, hash))?;
                    return execute_sign(id, receiver, parties, key, hash).await;
                }
            },
            Some(IncomingMessage::Close) => Err(anyhow!("external close"))?,
            None => Err(anyhow!("execution receiver is closed"))?,
            _ => log(format!("[{}] Unexpected incoming message", id))?,
        }
    }
}

pub fn connect_logger(logs: StreamSink<String>) -> Result<()> {
    initialize_logger(logs)?;
    log(format!("Logger is initialized"))?;
    Ok(())
}

/// Returns next available id for initialize execution
pub fn get_next_id() -> Result<u32> {
    global::get_id()
}

/// Creates channel to obtain outgoing messages for broadcast/send them
pub fn initialize(outgoing: StreamSink<OutgoingMessage>, id: u32) -> Result<()> {
    global::store_outgoin(id, outgoing)?;
    global::send_outgoin(id, OutgoingMessage::Start)?;

    {
        let receiver = global::create_incoming(id)?;
        global::runtime()?.spawn(async move {
            // execute
            match execution_loop(id, receiver).await {
                Ok(encoded) => {
                    global::send_outgoin(id, OutgoingMessage::Result { encoded }).unwrap()
                }
                Err(e) => global::send_outgoin(
                    id,
                    OutgoingMessage::critical(format!("Execution failed: {:?}", e)),
                )
                .unwrap(),
            }
        });
    }

    Ok(())
}

pub fn receive(id: u32, value: IncomingMessage) -> Result<()> {
    global::get_incomings()?
        .get_mut(&id)
        .ok_or(anyhow!("failed getting incoming stream"))?
        .try_send(value)
        .map_err(|e| anyhow!(format!("Failed send: {:?}", e)))
    // .map_err(|e| anyhow!(format!("Failed send {:?}", e)))
}

pub fn to_message_hash(tx_request: String) -> Result<String> {
    crate::ethers::to_message_hash(tx_request)
}

pub fn convert_to_ethers_signature(tx_request: String, signature: String) -> Result<String> {
    crate::ethers::convert_to_ethers_signature(tx_request, signature)
}

pub fn encode_transaction(tx_request: String, signature: String) -> Result<Vec<u8>> {
    crate::ethers::encode_transaction(tx_request, signature)
}

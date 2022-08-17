use std::sync::Mutex;
use std::{collections::HashMap, time::Duration};

use crate::ecdsa::signer::{sign_offline, sign_online};
use anyhow::{anyhow, Context, Error, Result};
use curv::elliptic::curves::Secp256k1;
use flutter_rust_bridge::{support, StreamSink};
use futures::{channel::mpsc::Sender, StreamExt};
use round_based::Msg;
use serde::de::DeserializeOwned;
use serde::{Deserialize, Serialize};
use tss::ecdsa::state_machine::keygen::LocalKey;

support::lazy_static! {
    static ref OUTGOING: Mutex<HashMap<u32, StreamSink<OutgoingMessage>>> = Mutex::new(HashMap::new());
    static ref INCOMING: Mutex<HashMap<u32, Sender<IncomingMessage>>> = Mutex::new(HashMap::new());
    static ref RUNTIME: Mutex<tokio::runtime::Runtime> = Mutex::new(tokio::runtime::Runtime::new().unwrap());
}

#[derive(Debug, Serialize, Deserialize)]
pub enum OutgoingMessage {
    Msg(String),
    Multiply(u32),
    Close,
}

#[derive(Debug, Serialize, Deserialize)]
pub enum IncomingMessage {
    Msg(String),
    Multiply(u32),
    Close,
}

/// Creates channel to obtain outgoing messages for broadcast/send them
pub fn create_outgoing_stream(outgoing: StreamSink<OutgoingMessage>, id: u32) -> Result<()> {
    let mut map = OUTGOING.lock().unwrap();

    if map.contains_key(&id) {
        return Err(anyhow!("Already exist id!"));
    }
    map.insert(id, outgoing);
    Ok(())
}

pub fn close_outgoin_stream(id: u32) {
    let _ = INCOMING
        .lock()
        .unwrap()
        .get_mut(&id)
        .unwrap()
        .try_send(IncomingMessage::Close);
    let _ = OUTGOING.lock().unwrap().remove(&id);
}

pub fn sign(id: u32, key: String, parties: Vec<u16>, index: u16) -> Result<()> {
    let runtime = RUNTIME.lock().unwrap();

    let key: LocalKey<Secp256k1> = serde_json::from_str(key.as_str()).unwrap();

    let stage = runtime.block_on(async move {
        let mut map = OUTGOING.lock().map_err(|e| anyhow!("failed"))?;
        let outgoing = map.get_mut(&id).ok_or(anyhow!("Stream not found"))?;

        let (sender, mut receiver) = futures::channel::mpsc::channel(102400);
        {
            INCOMING.lock().unwrap().insert(id, sender);
        };

        let stage = sign_offline(outgoing, &mut receiver, index, key, parties)
            .await
            .context("stage failed")?;

        Ok::<_, Error>(stage)
    })?;

    Ok::<(), Error>(())
}

pub fn multiply_incoming(id: u32) -> Result<u32> {
    let runtime = RUNTIME.lock().unwrap();

    Ok(runtime.block_on(async {
        let (sender, mut receiver) = futures::channel::mpsc::channel(102400);
        // Store channel
        {
            INCOMING.lock().unwrap().insert(id, sender);
        }

        let mut result = 0u32;

        loop {
            if let Some(incoming) = receiver.next().await {
                match incoming {
                    IncomingMessage::Multiply(value) => {
                        tokio::time::sleep(Duration::from_millis(500)).await;
                        OUTGOING
                            .lock()
                            .unwrap()
                            .get(&id)
                            .unwrap()
                            .add(OutgoingMessage::Multiply(value * 2));
                        result = value * 2;

                        if result > 10 {
                            OUTGOING
                                .lock()
                                .unwrap()
                                .get(&id)
                                .unwrap()
                                .add(OutgoingMessage::Close);
                            break;
                        }
                    }
                    IncomingMessage::Close => {
                        OUTGOING
                            .lock()
                            .unwrap()
                            .get(&id)
                            .unwrap()
                            .add(OutgoingMessage::Close);
                        break;
                    }
                    _ => {}
                }
            }

            tokio::time::sleep(Duration::from_millis(100)).await;
        }

        result
    }))
}

pub fn send_incoming(id: u32, value: IncomingMessage) -> Result<()> {
    Ok(INCOMING
        .lock()
        .unwrap()
        .get_mut(&id)
        .context("channel not found")?
        .try_send(value)?)
}

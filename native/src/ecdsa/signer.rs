use core::num;
use std::cell::RefCell;
use std::collections::HashMap;
use std::sync::RwLock;

use anyhow::{anyhow, Context, Error, Result};
use curv::BigInt;
use curv::{arithmetic::Converter, elliptic::curves::Secp256k1};
use flutter_rust_bridge::StreamSink;
use futures::channel::mpsc::{Receiver, Sender};
use futures::{FutureExt, Sink, Stream, StreamExt, TryStreamExt};
use tss::ecdsa::party_i::SignatureRecid;
use std::convert::TryInto;

use round_based::async_runtime::AsyncProtocol;
use round_based::Msg;
use serde::de::DeserializeOwned;
use serde::Serialize;
use tss::ecdsa::state_machine::sign::{
    CompletedOfflineStage, OfflineProtocolMessage, PartialSignature,
};
use tss::ecdsa::state_machine::{
    keygen::LocalKey,
    sign::{OfflineStage, SignManual},
};

use crate::api::{IncomingMessage, OutgoingMessage};

pub async fn sign_offline(
    outgoing: &mut StreamSink<OutgoingMessage>,
    incoming: &mut Receiver<IncomingMessage>,
    index: u16,
    local_share: LocalKey<Secp256k1>,
    parties: Vec<u16>,
) -> Result<CompletedOfflineStage> {
    // Construct channel of outgoing messages
    let outgoing = futures::sink::unfold(
        outgoing,
        |client, message: Msg<OfflineProtocolMessage>| async move {
            let serialized = serde_json::to_string(&message).context("serialize message")?;
            client.add(OutgoingMessage::Msg(serialized.into()));
            Ok::<_, anyhow::Error>(client)
        },
    );

    // // parse
    let incoming = incoming.map(move |msg| match msg {
        IncomingMessage::Msg(raw) => {
            Ok(serde_json::from_str(raw.as_str()).context("deserialization")?)
        }
        _ => Err(anyhow!("incorrect")),
    });

    let incoming = incoming.fuse();

    tokio::pin!(incoming);
    tokio::pin!(outgoing);

    let number_of_parties = parties.len();
    let signing = OfflineStage::new(index, parties, local_share)?;

    let completed_offline_stage = AsyncProtocol::new(signing, incoming, outgoing)
        .run()
        .await
        .map_err(|e| anyhow!("protocol execution terminated with error: {}", e))?;
    // .map_err(|e| anyhow!("protocol execution terminated with error: {:?}", e))?;

    Ok::<_, Error>(completed_offline_stage)
}

pub async fn sign_online(
    outgoing: StreamSink<OutgoingMessage>,
    incoming: Receiver<IncomingMessage>,
    completed_offline_stage: CompletedOfflineStage,
    parties: Vec<u16>,
    index: u16,
    hash: &[u8],
) -> Result<SignatureRecid> {
    let (signing, partial_signature) =
        SignManual::new(BigInt::from_bytes(hash), completed_offline_stage)?;

    let number_of_parties = parties.len();
    let partial_sig_msg = Msg {
        sender: index,
        receiver: None,
        body: partial_signature,
    };

    outgoing.add(OutgoingMessage::Msg(
        serde_json::to_string(&partial_sig_msg).context("failed serialization")?,
    ));

    let incoming = incoming.map(move |msg| match msg {
        IncomingMessage::Msg(raw) => Ok(
            serde_json::from_str::<PartialSignature>(raw.as_str()).context("deserialization")?
        ),
        _ => Err(anyhow!("incorrect")),
    });

    let partial_signatures: Vec<_> = incoming
        .take(number_of_parties - 1)
        .map_ok(|msg| msg)
        .try_collect()
        .await?;

    let signature = signing
        .complete(&partial_signatures)
        .context("online stage failed")?;

    Ok(signature)
}

// pub async fn sign(relay: surf::Url, room: String, key: String, parties: Vec<u16>, hash: String) -> Result<String> {
//     let local_share = serde_json::from_str(key.as_str()).context("Unable to parse provided key")?;
//     let number_of_parties = parties.len();

//     let (i, incoming, outgoing) =
//         join_computation(relay.clone(), &format!("{}-offline", room))
//             .await
//             .context("join offline computation")?;

//     let incoming = incoming.fuse();
//     tokio::pin!(incoming);
//     tokio::pin!(outgoing);

//     let signing = OfflineStage::new(i, parties, local_share)?;
//     let completed_offline_stage = AsyncProtocol::new(signing, incoming, outgoing)
//         .run()
//         .await
//         .map_err(|e| anyhow!("protocol execution terminated with error: {}", e))?;

//     let (_i, incoming, outgoing) = join_computation(relay, &format!("{}-online", room))
//         .await
//         .context("join online computation")?;

//     tokio::pin!(incoming);
//     tokio::pin!(outgoing);

//     let (signing, partial_signature) = SignManual::new(
//         BigInt::from_bytes(hash.as_bytes()),
//         completed_offline_stage,
//     )?;

//     outgoing
//         .send(Msg {
//             sender: i,
//             receiver: None,
//             body: partial_signature,
//         })
//         .await?;

//     let partial_signatures: Vec<_> = incoming
//         .take(number_of_parties - 1)
//         .map_ok(|msg| msg.body)
//         .try_collect()
//         .await?;
//     let signature = signing
//         .complete(&partial_signatures)
//         .context("online stage failed")?;
//     let signature = serde_json::to_string(&signature).context("serialize signature")?;

//     Ok(signature)
// }

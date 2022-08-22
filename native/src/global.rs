use std::{
    collections::HashMap,
    sync::{atomic::AtomicU32, Mutex, RwLock},
};

use crate::api::*;
use anyhow::{anyhow, Context, Result};
use flutter_rust_bridge::{support, StreamSink};
use futures::channel::mpsc::{channel, Receiver, Sender};
use tokio::runtime::Runtime;

support::lazy_static! {
    static ref OUTGOING: Mutex<HashMap<u32, StreamSink<OutgoingMessage>>> = Mutex::new(HashMap::new());
    static ref INCOMING: Mutex<HashMap<u32, Sender<IncomingMessage>>> = Mutex::new(HashMap::new());
    static ref RUNTIME: RwLock<Runtime> = RwLock::new(tokio::runtime::Runtime::new().unwrap());
    static ref LAST_ID: AtomicU32 = AtomicU32::new(0);
}

pub(crate) fn store_outgoin(id: u32, outgoing: StreamSink<OutgoingMessage>) -> Result<()> {
    if OUTGOING
        .lock()
        .map_err(|e| anyhow!("failed read outgoin map: {}", e))?
        .contains_key(&id)
    {
        Err(anyhow!("Already exist outgoin channel ({})", id))
    } else {
        OUTGOING
            .lock()
            .map_err(|e| anyhow!("failed to get mutable map of outgoing: {}", e))?
            .insert(id, outgoing);
        Ok(())
    }
}

pub(crate) fn create_incoming(id: u32) -> Result<Receiver<IncomingMessage>> {
    if INCOMING
        .lock()
        .map_err(|e| anyhow!("failed read incoming map: {}", e))?
        .contains_key(&id)
    {
        Err(anyhow!("Already exist incoming channel ({})", id))
    } else {
        let (sender, receiver) = channel::<IncomingMessage>(102400);

        INCOMING
            .lock()
            .map_err(|e| anyhow!("failed to get mutable map of incoming: {}", e))?
            .insert(id, sender);

        Ok(receiver)
    }
}

pub(crate) fn send_outgoin(id: u32, msg: OutgoingMessage) -> Result<()> {
    let error = format!("{}", msg);
    match !OUTGOING
        .lock()
        .map_err(|e| anyhow!("failed read outgoing map: {}", e))?
        .get(&id)
        .context("channel not found")?
        .add(msg)
    {
        true => Err(anyhow!("failed to send outgoin message: {}", error)),
        false => Ok(()),
    }
}

pub(crate) fn get_id() -> Result<u32> {
    Ok(LAST_ID.fetch_add(1, std::sync::atomic::Ordering::SeqCst) + 1)
}

pub(crate) fn runtime() -> Result<std::sync::RwLockReadGuard<'static, Runtime>> {
    RUNTIME
        .read()
        .map_err(|e| anyhow!("failed read runtime: {}", e))
}

pub(crate) fn get_incomings(
) -> Result<std::sync::MutexGuard<'static, HashMap<u32, Sender<IncomingMessage>>>, anyhow::Error>
{
    INCOMING
        .lock()
        .map_err(|e| anyhow!("Failed read incomings map: {}", e))
}

use std::ops::Deref;
use anyhow::{Context};
use flutter_rust_bridge::{StreamSink,frb};
use hex::ToHex;
use tookey_libtss::curv::elliptic::curves::Secp256k1;
use tookey_libtss::ecdsa::state_machine::keygen::LocalKey;
use crate::global;
use crate::logger::{initialize_logger, log};
pub use tookey_libtss::keygen::{KeygenParams, KeygenResult};
pub use tookey_libtss::sign::{SignParams, SignResult};

pub fn connect_logger(logs: StreamSink<String>) -> anyhow::Result<()> {
    initialize_logger(logs)?;
    log("Logger is initialized".to_string())?;
    Ok(())
}

pub fn to_public_key(key: String, _compressed: bool) -> anyhow::Result<String> {
    let local_share: LocalKey<Secp256k1> =
        serde_json::from_str(key.as_str()).context("key deserialization")?;
    let pk = local_share.public_key();

    Ok(pk.to_bytes(true).deref().encode_hex())
}

pub fn to_ethereum_address(key: String) -> anyhow::Result<String> {
    crate::ethers::to_ethereum_address(key)
}

pub fn to_message_hash(tx_request: String) -> anyhow::Result<String> {
    crate::ethers::to_message_hash(tx_request)
}

pub fn convert_to_ethers_signature(tx_request: String, signature: String) -> anyhow::Result<String> {
    crate::ethers::convert_to_ethers_signature(tx_request, signature)
}

pub fn encode_transaction(tx_request: String, signature: String) -> anyhow::Result<Vec<u8>> {
    crate::ethers::encode_transaction(tx_request, signature)
}

#[frb(mirror(KeygenParams))]
pub struct _KeygenParams {
    pub room_id: String,
    pub participant_index: u16,
    pub participants_count: u16,
    pub participants_threshold: u16,
    pub relay_address: String,
    pub timeout_seconds: u16,
}

#[frb(mirror(KeygenResult))]
pub struct _KeygenResult {
    pub key: Option<String>,
    pub error: Option<String>,
}

pub fn keygen(params: KeygenParams) -> KeygenResult {
    global::runtime().unwrap().block_on(async move {
        tookey_libtss::keygen::keygen(params).await
    })
}

#[frb(mirror(SignParams))]
pub struct _SignParams {
    pub room_id: String,
    pub key: String,
    pub data: String,
    pub participants_indexes: Vec<u16>,
    pub relay_address: String,
    pub timeout_seconds: u16,
}

#[frb(mirror(SignResult))]
pub struct _SignResult {
    pub result: Option<String>,
    pub error: Option<String>,
}

pub fn sign(params: SignParams) -> SignResult {
    global::runtime().unwrap().block_on(async move {
        tookey_libtss::sign::sign(params).await
    })
}

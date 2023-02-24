
use flutter_rust_bridge::{frb, StreamSink};
use std::sync::{Mutex, RwLock};
use tokio::runtime::Runtime;
pub use tookey_libtss::keygen::{KeygenParams, KeygenResult};
pub use tookey_libtss::sign::{SignParams, SignResult};

flutter_rust_bridge::support::lazy_static! {
    static ref RUNTIME: RwLock<Runtime> = RwLock::new(tokio::runtime::Runtime::new().unwrap());
    static ref LOGGER: Mutex<Option<StreamSink<String>>> = Mutex::new(None);
}

///
/// Internal functions
///
fn runtime() -> anyhow::Result<std::sync::RwLockReadGuard<'static, Runtime>> {
    RUNTIME
        .read()
        .map_err(|e| anyhow::anyhow!("failed read runtime: {}", e))
}

fn log(line: String) -> anyhow::Result<()> {
    LOGGER
        .lock()
        .map_err(|e| anyhow::anyhow!("Failed to log LOGS: {}", e))?
        .as_ref()
        .ok_or_else(|| anyhow::anyhow!("logger is not initialized"))?
        .add(line);

    Ok(())
}

///
/// Public interface
///
pub fn connect_logger(stream: StreamSink<String>) -> anyhow::Result<()> {
    let mut logger = LOGGER.lock().map_err(|_e| anyhow::anyhow!("Failed to log LOGS"))?;
    *logger = Some(stream);

    log("Logger is initialized".to_string())?;
    Ok(())
}

#[allow(dead_code)]
pub fn public_key_to_ethereum_address(public_key: String) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::public_key_to_ethereum_address(public_key)
}

pub fn private_key_to_public_key(private_key: String, compressed: bool) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::private_key_to_public_key(private_key, Some(compressed))
}

pub fn private_key_to_ethereum_address(private_key: String) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::private_key_to_ethereum_address(private_key)
}

pub fn transaction_to_message_hash(tx_request: String) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::transaction_to_message_hash(tx_request)
}

pub fn message_to_hash(data: String) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::message_to_hash(data)
}

pub fn encode_message_signature(
    message_hash: String,
    chain_id: u32,
    signature_recid: String,
) -> anyhow::Result<String> {
    tookey_libtss_ethereum::ethers::encode_message_signature(message_hash, chain_id, signature_recid)
}

pub fn encode_transaction(tx_request: String, signature_recid: String) -> anyhow::Result<Vec<u8>> {
    tookey_libtss_ethereum::ethers::encode_transaction(tx_request, signature_recid)
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
    runtime()
        .unwrap()
        .block_on(async move { tookey_libtss::keygen::keygen(params).await })
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
    runtime()
        .unwrap()
        .block_on(async move { tookey_libtss::sign::sign(params).await })
}

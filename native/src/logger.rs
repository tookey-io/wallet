use std::sync::Mutex;

use anyhow::{anyhow, Result};
use flutter_rust_bridge::StreamSink;

flutter_rust_bridge::support::lazy_static! {
    static ref LOGGER: Mutex<Option<StreamSink<String>>> = Mutex::new(None);
}

pub fn initialize_logger(stream: StreamSink<String>) -> Result<()> {
    let mut logger = LOGGER.lock().map_err(|_e| anyhow!("Failed to log LOGS"))?;
    *logger = Some(stream);
    Ok(())
}

pub fn log(line: String) -> Result<()> {
    LOGGER
        .lock()
        .map_err(|e| anyhow!("Failed to log LOGS: {}", e))?
        .as_ref()
        .ok_or(anyhow!("logger is not initialized"))?
        .add(line);

    Ok(())
}

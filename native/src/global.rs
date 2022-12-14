use std::{
    sync::{RwLock},
};

use anyhow::{anyhow, Result};
use flutter_rust_bridge::{support};
use tokio::runtime::Runtime;

support::lazy_static! {
    static ref RUNTIME: RwLock<Runtime> = RwLock::new(tokio::runtime::Runtime::new().unwrap());
}

pub(crate) fn runtime() -> Result<std::sync::RwLockReadGuard<'static, Runtime>> {
    RUNTIME
        .read()
        .map_err(|e| anyhow!("failed read runtime: {}", e))
}

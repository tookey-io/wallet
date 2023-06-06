#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case,
    clippy::too_many_arguments
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.77.1.

use crate::api::*;
use core::panic::UnwindSafe;
use flutter_rust_bridge::*;
use std::ffi::c_void;
use std::sync::Arc;

// Section: imports

// Section: wire functions

fn wire_connect_logger_impl(port_: MessagePort) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "connect_logger",
            port: Some(port_),
            mode: FfiCallMode::Stream,
        },
        move || move |task_callback| connect_logger(task_callback.stream_sink()),
    )
}
fn wire_public_key_to_ethereum_address_impl(port_: MessagePort, public_key: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "public_key_to_ethereum_address",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_public_key = public_key.wire2api();
            move |task_callback| public_key_to_ethereum_address(api_public_key)
        },
    )
}
fn wire_private_key_to_public_key_impl(
    port_: MessagePort,
    private_key: impl Wire2Api<String> + UnwindSafe,
    compressed: impl Wire2Api<bool> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "private_key_to_public_key",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_private_key = private_key.wire2api();
            let api_compressed = compressed.wire2api();
            move |task_callback| private_key_to_public_key(api_private_key, api_compressed)
        },
    )
}
fn wire_private_key_to_ethereum_address_impl(port_: MessagePort, private_key: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "private_key_to_ethereum_address",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_private_key = private_key.wire2api();
            move |task_callback| private_key_to_ethereum_address(api_private_key)
        },
    )
}
fn wire_transaction_to_message_hash_impl(port_: MessagePort, tx_request: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "transaction_to_message_hash",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_tx_request = tx_request.wire2api();
            move |task_callback| transaction_to_message_hash(api_tx_request)
        },
    )
}
fn wire_message_to_hash_impl(port_: MessagePort, data: impl Wire2Api<String> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "message_to_hash",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_data = data.wire2api();
            move |task_callback| message_to_hash(api_data)
        },
    )
}
fn wire_encode_message_signature_impl(
    port_: MessagePort,
    message_hash: impl Wire2Api<String> + UnwindSafe,
    chain_id: impl Wire2Api<u32> + UnwindSafe,
    signature_recid: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "encode_message_signature",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_message_hash = message_hash.wire2api();
            let api_chain_id = chain_id.wire2api();
            let api_signature_recid = signature_recid.wire2api();
            move |task_callback| encode_message_signature(api_message_hash, api_chain_id, api_signature_recid)
        },
    )
}
fn wire_encode_transaction_impl(
    port_: MessagePort,
    tx_request: impl Wire2Api<String> + UnwindSafe,
    signature_recid: impl Wire2Api<String> + UnwindSafe,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "encode_transaction",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_tx_request = tx_request.wire2api();
            let api_signature_recid = signature_recid.wire2api();
            move |task_callback| encode_transaction(api_tx_request, api_signature_recid)
        },
    )
}
fn wire_keygen_impl(port_: MessagePort, params: impl Wire2Api<KeygenParams> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "keygen",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_params = params.wire2api();
            move |task_callback| Ok(mirror_KeygenResult(keygen(api_params)))
        },
    )
}
fn wire_sign_impl(port_: MessagePort, params: impl Wire2Api<SignParams> + UnwindSafe) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "sign",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_params = params.wire2api();
            move |task_callback| Ok(mirror_SignResult(sign(api_params)))
        },
    )
}
// Section: wrapper structs

#[derive(Clone)]
struct mirror_KeygenResult(KeygenResult);

#[derive(Clone)]
struct mirror_SignResult(SignResult);

// Section: static checks

const _: fn() = || {
    {
        let KeygenResult = None::<KeygenResult>.unwrap();
        let _: Option<String> = KeygenResult.key;
        let _: Option<String> = KeygenResult.error;
    }
    {
        let SignResult = None::<SignResult>.unwrap();
        let _: Option<String> = SignResult.result;
        let _: Option<String> = SignResult.error;
    }
};
// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        (!self.is_null()).then(|| self.wire2api())
    }
}

impl Wire2Api<bool> for bool {
    fn wire2api(self) -> bool {
        self
    }
}

impl Wire2Api<u16> for u16 {
    fn wire2api(self) -> u16 {
        self
    }
}
impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}
impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

// Section: impl IntoDart

impl support::IntoDart for mirror_KeygenResult {
    fn into_dart(self) -> support::DartAbi {
        vec![self.0.key.into_dart(), self.0.error.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for mirror_KeygenResult {}

impl support::IntoDart for mirror_SignResult {
    fn into_dart(self) -> support::DartAbi {
        vec![self.0.result.into_dart(), self.0.error.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for mirror_SignResult {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

#[cfg(not(target_family = "wasm"))]
#[path = "bridge_generated.io.rs"]
mod io;
#[cfg(not(target_family = "wasm"))]
pub use io::*;

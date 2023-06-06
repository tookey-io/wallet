use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_connect_logger(port_: i64) {
    wire_connect_logger_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_public_key_to_ethereum_address(port_: i64, public_key: *mut wire_uint_8_list) {
    wire_public_key_to_ethereum_address_impl(port_, public_key)
}

#[no_mangle]
pub extern "C" fn wire_private_key_to_public_key(port_: i64, private_key: *mut wire_uint_8_list, compressed: bool) {
    wire_private_key_to_public_key_impl(port_, private_key, compressed)
}

#[no_mangle]
pub extern "C" fn wire_private_key_to_ethereum_address(port_: i64, private_key: *mut wire_uint_8_list) {
    wire_private_key_to_ethereum_address_impl(port_, private_key)
}

#[no_mangle]
pub extern "C" fn wire_transaction_to_message_hash(port_: i64, tx_request: *mut wire_uint_8_list) {
    wire_transaction_to_message_hash_impl(port_, tx_request)
}

#[no_mangle]
pub extern "C" fn wire_message_to_hash(port_: i64, data: *mut wire_uint_8_list) {
    wire_message_to_hash_impl(port_, data)
}

#[no_mangle]
pub extern "C" fn wire_encode_message_signature(
    port_: i64,
    message_hash: *mut wire_uint_8_list,
    chain_id: u32,
    signature_recid: *mut wire_uint_8_list,
) {
    wire_encode_message_signature_impl(port_, message_hash, chain_id, signature_recid)
}

#[no_mangle]
pub extern "C" fn wire_encode_transaction(
    port_: i64,
    tx_request: *mut wire_uint_8_list,
    signature_recid: *mut wire_uint_8_list,
) {
    wire_encode_transaction_impl(port_, tx_request, signature_recid)
}

#[no_mangle]
pub extern "C" fn wire_keygen(port_: i64, params: *mut wire_KeygenParams) {
    wire_keygen_impl(port_, params)
}

#[no_mangle]
pub extern "C" fn wire_sign(port_: i64, params: *mut wire_SignParams) {
    wire_sign_impl(port_, params)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_keygen_params_0() -> *mut wire_KeygenParams {
    support::new_leak_box_ptr(wire_KeygenParams::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_sign_params_0() -> *mut wire_SignParams {
    support::new_leak_box_ptr(wire_SignParams::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_uint_16_list_0(len: i32) -> *mut wire_uint_16_list {
    let ans = wire_uint_16_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}

impl Wire2Api<KeygenParams> for *mut wire_KeygenParams {
    fn wire2api(self) -> KeygenParams {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<KeygenParams>::wire2api(*wrap).into()
    }
}
impl Wire2Api<SignParams> for *mut wire_SignParams {
    fn wire2api(self) -> SignParams {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<SignParams>::wire2api(*wrap).into()
    }
}
impl Wire2Api<KeygenParams> for wire_KeygenParams {
    fn wire2api(self) -> KeygenParams {
        KeygenParams {
            room_id: self.room_id.wire2api(),
            participant_index: self.participant_index.wire2api(),
            participants_count: self.participants_count.wire2api(),
            participants_threshold: self.participants_threshold.wire2api(),
            relay_address: self.relay_address.wire2api(),
            timeout_seconds: self.timeout_seconds.wire2api(),
        }
    }
}
impl Wire2Api<SignParams> for wire_SignParams {
    fn wire2api(self) -> SignParams {
        SignParams {
            room_id: self.room_id.wire2api(),
            key: self.key.wire2api(),
            data: self.data.wire2api(),
            participants_indexes: self.participants_indexes.wire2api(),
            relay_address: self.relay_address.wire2api(),
            timeout_seconds: self.timeout_seconds.wire2api(),
        }
    }
}

impl Wire2Api<Vec<u16>> for *mut wire_uint_16_list {
    fn wire2api(self) -> Vec<u16> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_KeygenParams {
    room_id: *mut wire_uint_8_list,
    participant_index: u16,
    participants_count: u16,
    participants_threshold: u16,
    relay_address: *mut wire_uint_8_list,
    timeout_seconds: u16,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_SignParams {
    room_id: *mut wire_uint_8_list,
    key: *mut wire_uint_8_list,
    data: *mut wire_uint_8_list,
    participants_indexes: *mut wire_uint_16_list,
    relay_address: *mut wire_uint_8_list,
    timeout_seconds: u16,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_16_list {
    ptr: *mut u16,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_KeygenParams {
    fn new_with_null_ptr() -> Self {
        Self {
            room_id: core::ptr::null_mut(),
            participant_index: Default::default(),
            participants_count: Default::default(),
            participants_threshold: Default::default(),
            relay_address: core::ptr::null_mut(),
            timeout_seconds: Default::default(),
        }
    }
}

impl Default for wire_KeygenParams {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

impl NewWithNullPtr for wire_SignParams {
    fn new_with_null_ptr() -> Self {
        Self {
            room_id: core::ptr::null_mut(),
            key: core::ptr::null_mut(),
            data: core::ptr::null_mut(),
            participants_indexes: core::ptr::null_mut(),
            relay_address: core::ptr::null_mut(),
            timeout_seconds: Default::default(),
        }
    }
}

impl Default for wire_SignParams {
    fn default() -> Self {
        Self::new_with_null_ptr()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}

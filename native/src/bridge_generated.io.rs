use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_to_public_key(port_: i64, key: *mut wire_uint_8_list, compressed: bool) {
    wire_to_public_key_impl(port_, key, compressed)
}

#[no_mangle]
pub extern "C" fn wire_to_ethereum_address(port_: i64, key: *mut wire_uint_8_list) {
    wire_to_ethereum_address_impl(port_, key)
}

#[no_mangle]
pub extern "C" fn wire_message_to_hash(port_: i64, message: *mut wire_uint_8_list) {
    wire_message_to_hash_impl(port_, message)
}

#[no_mangle]
pub extern "C" fn wire_to_ethereum_signature(
    port_: i64,
    message: *mut wire_uint_8_list,
    signature: *mut wire_uint_8_list,
    chain: u32,
) {
    wire_to_ethereum_signature_impl(port_, message, signature, chain)
}

#[no_mangle]
pub extern "C" fn wire_connect_logger(port_: i64) {
    wire_connect_logger_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_get_next_id(port_: i64) {
    wire_get_next_id_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_initialize(port_: i64, id: u32) {
    wire_initialize_impl(port_, id)
}

#[no_mangle]
pub extern "C" fn wire_receive(port_: i64, id: u32, value: *mut wire_IncomingMessage) {
    wire_receive_impl(port_, id, value)
}

#[no_mangle]
pub extern "C" fn wire_to_message_hash(port_: i64, tx_request: *mut wire_uint_8_list) {
    wire_to_message_hash_impl(port_, tx_request)
}

#[no_mangle]
pub extern "C" fn wire_convert_to_ethers_signature(
    port_: i64,
    tx_request: *mut wire_uint_8_list,
    signature: *mut wire_uint_8_list,
) {
    wire_convert_to_ethers_signature_impl(port_, tx_request, signature)
}

#[no_mangle]
pub extern "C" fn wire_encode_transaction(
    port_: i64,
    tx_request: *mut wire_uint_8_list,
    signature: *mut wire_uint_8_list,
) {
    wire_encode_transaction_impl(port_, tx_request, signature)
}

#[no_mangle]
pub extern "C" fn wire_critical__static_method__OutgoingMessage(
    port_: i64,
    message: *mut wire_uint_8_list,
) {
    wire_critical__static_method__OutgoingMessage_impl(port_, message)
}

#[no_mangle]
pub extern "C" fn wire_invalid__static_method__OutgoingMessage(
    port_: i64,
    message: *mut wire_uint_8_list,
) {
    wire_invalid__static_method__OutgoingMessage_impl(port_, message)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_incoming_message_0() -> *mut wire_IncomingMessage {
    support::new_leak_box_ptr(wire_IncomingMessage::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_tookey_scenarios_0() -> *mut wire_TookeyScenarios {
    support::new_leak_box_ptr(wire_TookeyScenarios::new_with_null_ptr())
}

#[no_mangle]
pub extern "C" fn new_box_autoadd_u16_0(value: u16) -> *mut u16 {
    support::new_leak_box_ptr(value)
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

impl Wire2Api<IncomingMessage> for *mut wire_IncomingMessage {
    fn wire2api(self) -> IncomingMessage {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<IncomingMessage>::wire2api(*wrap).into()
    }
}
impl Wire2Api<TookeyScenarios> for *mut wire_TookeyScenarios {
    fn wire2api(self) -> TookeyScenarios {
        let wrap = unsafe { support::box_from_leak_ptr(self) };
        Wire2Api::<TookeyScenarios>::wire2api(*wrap).into()
    }
}

impl Wire2Api<IncomingMessage> for wire_IncomingMessage {
    fn wire2api(self) -> IncomingMessage {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Begin);
                IncomingMessage::Begin {
                    scenario: ans.scenario.wire2api(),
                }
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Participant);
                IncomingMessage::Participant {
                    index: ans.index.wire2api(),
                    party: ans.party.wire2api(),
                }
            },
            2 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Group);
                IncomingMessage::Group {
                    indexes: ans.indexes.wire2api(),
                    parties: ans.parties.wire2api(),
                }
            },
            3 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.Communication);
                IncomingMessage::Communication {
                    packet: ans.packet.wire2api(),
                }
            },
            4 => IncomingMessage::Close,
            _ => unreachable!(),
        }
    }
}

impl Wire2Api<TookeyScenarios> for wire_TookeyScenarios {
    fn wire2api(self) -> TookeyScenarios {
        match self.tag {
            0 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.KeygenECDSA);
                TookeyScenarios::KeygenECDSA {
                    index: ans.index.wire2api(),
                    parties: ans.parties.wire2api(),
                    threashold: ans.threashold.wire2api(),
                }
            },
            1 => unsafe {
                let ans = support::box_from_leak_ptr(self.kind);
                let ans = support::box_from_leak_ptr(ans.SignECDSA);
                TookeyScenarios::SignECDSA {
                    parties: ans.parties.wire2api(),
                    key: ans.key.wire2api(),
                    hash: ans.hash.wire2api(),
                }
            },
            _ => unreachable!(),
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

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage {
    tag: i32,
    kind: *mut IncomingMessageKind,
}

#[repr(C)]
pub union IncomingMessageKind {
    Begin: *mut wire_IncomingMessage_Begin,
    Participant: *mut wire_IncomingMessage_Participant,
    Group: *mut wire_IncomingMessage_Group,
    Communication: *mut wire_IncomingMessage_Communication,
    Close: *mut wire_IncomingMessage_Close,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage_Begin {
    scenario: *mut wire_TookeyScenarios,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage_Participant {
    index: u16,
    party: *mut u16,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage_Group {
    indexes: *mut wire_uint_16_list,
    parties: *mut wire_uint_16_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage_Communication {
    packet: *mut wire_uint_8_list,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_IncomingMessage_Close {}

#[repr(C)]
#[derive(Clone)]
pub struct wire_TookeyScenarios {
    tag: i32,
    kind: *mut TookeyScenariosKind,
}

#[repr(C)]
pub union TookeyScenariosKind {
    KeygenECDSA: *mut wire_TookeyScenarios_KeygenECDSA,
    SignECDSA: *mut wire_TookeyScenarios_SignECDSA,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_TookeyScenarios_KeygenECDSA {
    index: u16,
    parties: u16,
    threashold: u16,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_TookeyScenarios_SignECDSA {
    parties: *mut wire_uint_16_list,
    key: *mut wire_uint_8_list,
    hash: *mut wire_uint_8_list,
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

impl NewWithNullPtr for wire_IncomingMessage {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_IncomingMessage_Begin() -> *mut IncomingMessageKind {
    support::new_leak_box_ptr(IncomingMessageKind {
        Begin: support::new_leak_box_ptr(wire_IncomingMessage_Begin {
            scenario: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_IncomingMessage_Participant() -> *mut IncomingMessageKind {
    support::new_leak_box_ptr(IncomingMessageKind {
        Participant: support::new_leak_box_ptr(wire_IncomingMessage_Participant {
            index: Default::default(),
            party: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_IncomingMessage_Group() -> *mut IncomingMessageKind {
    support::new_leak_box_ptr(IncomingMessageKind {
        Group: support::new_leak_box_ptr(wire_IncomingMessage_Group {
            indexes: core::ptr::null_mut(),
            parties: core::ptr::null_mut(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_IncomingMessage_Communication() -> *mut IncomingMessageKind {
    support::new_leak_box_ptr(IncomingMessageKind {
        Communication: support::new_leak_box_ptr(wire_IncomingMessage_Communication {
            packet: core::ptr::null_mut(),
        }),
    })
}

impl NewWithNullPtr for wire_TookeyScenarios {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: -1,
            kind: core::ptr::null_mut(),
        }
    }
}

#[no_mangle]
pub extern "C" fn inflate_TookeyScenarios_KeygenECDSA() -> *mut TookeyScenariosKind {
    support::new_leak_box_ptr(TookeyScenariosKind {
        KeygenECDSA: support::new_leak_box_ptr(wire_TookeyScenarios_KeygenECDSA {
            index: Default::default(),
            parties: Default::default(),
            threashold: Default::default(),
        }),
    })
}

#[no_mangle]
pub extern "C" fn inflate_TookeyScenarios_SignECDSA() -> *mut TookeyScenariosKind {
    support::new_leak_box_ptr(TookeyScenariosKind {
        SignECDSA: support::new_leak_box_ptr(wire_TookeyScenarios_SignECDSA {
            parties: core::ptr::null_mut(),
            key: core::ptr::null_mut(),
            hash: core::ptr::null_mut(),
        }),
    })
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturnStruct(val: support::WireSyncReturnStruct) {
    unsafe {
        let _ = support::vec_from_leak_ptr(val.ptr, val.len);
    }
}

use super::*;
// Section: wire functions

#[wasm_bindgen]
pub fn wire_connect_logger(port_: MessagePort) {
    wire_connect_logger_impl(port_)
}

#[wasm_bindgen]
pub fn wire_public_key_to_ethereum_address(port_: MessagePort, public_key: String) {
    wire_public_key_to_ethereum_address_impl(port_, public_key)
}

#[wasm_bindgen]
pub fn wire_private_key_to_public_key(port_: MessagePort, private_key: String, compressed: bool) {
    wire_private_key_to_public_key_impl(port_, private_key, compressed)
}

#[wasm_bindgen]
pub fn wire_private_key_to_ethereum_address(port_: MessagePort, private_key: String) {
    wire_private_key_to_ethereum_address_impl(port_, private_key)
}

#[wasm_bindgen]
pub fn wire_transaction_to_message_hash(port_: MessagePort, tx_request: String) {
    wire_transaction_to_message_hash_impl(port_, tx_request)
}

#[wasm_bindgen]
pub fn wire_message_to_hash(port_: MessagePort, data: String) {
    wire_message_to_hash_impl(port_, data)
}

#[wasm_bindgen]
pub fn wire_encode_message_signature(port_: MessagePort, message_hash: String, chain_id: u32, signature_recid: String) {
    wire_encode_message_signature_impl(port_, message_hash, chain_id, signature_recid)
}

#[wasm_bindgen]
pub fn wire_encode_transaction(port_: MessagePort, tx_request: String, signature_recid: String) {
    wire_encode_transaction_impl(port_, tx_request, signature_recid)
}

#[wasm_bindgen]
pub fn wire_keygen(port_: MessagePort, params: JsValue) {
    wire_keygen_impl(port_, params)
}

#[wasm_bindgen]
pub fn wire_sign(port_: MessagePort, params: JsValue) {
    wire_sign_impl(port_, params)
}

// Section: allocate functions

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for String {
    fn wire2api(self) -> String {
        self
    }
}

impl Wire2Api<KeygenParams> for JsValue {
    fn wire2api(self) -> KeygenParams {
        let self_ = self.dyn_into::<JsArray>().unwrap();
        assert_eq!(self_.length(), 6, "Expected 6 elements, got {}", self_.length());
        KeygenParams {
            room_id: self_.get(0).wire2api(),
            participant_index: self_.get(1).wire2api(),
            participants_count: self_.get(2).wire2api(),
            participants_threshold: self_.get(3).wire2api(),
            relay_address: self_.get(4).wire2api(),
            timeout_seconds: self_.get(5).wire2api(),
        }
    }
}
impl Wire2Api<SignParams> for JsValue {
    fn wire2api(self) -> SignParams {
        let self_ = self.dyn_into::<JsArray>().unwrap();
        assert_eq!(self_.length(), 6, "Expected 6 elements, got {}", self_.length());
        SignParams {
            room_id: self_.get(0).wire2api(),
            key: self_.get(1).wire2api(),
            data: self_.get(2).wire2api(),
            participants_indexes: self_.get(3).wire2api(),
            relay_address: self_.get(4).wire2api(),
            timeout_seconds: self_.get(5).wire2api(),
        }
    }
}

impl Wire2Api<Vec<u16>> for Box<[u16]> {
    fn wire2api(self) -> Vec<u16> {
        self.into_vec()
    }
}
impl Wire2Api<Vec<u8>> for Box<[u8]> {
    fn wire2api(self) -> Vec<u8> {
        self.into_vec()
    }
}
// Section: impl Wire2Api for JsValue

impl Wire2Api<String> for JsValue {
    fn wire2api(self) -> String {
        self.as_string().expect("non-UTF-8 string, or not a string")
    }
}
impl Wire2Api<bool> for JsValue {
    fn wire2api(self) -> bool {
        self.is_truthy()
    }
}
impl Wire2Api<u16> for JsValue {
    fn wire2api(self) -> u16 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<u32> for JsValue {
    fn wire2api(self) -> u32 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<u8> for JsValue {
    fn wire2api(self) -> u8 {
        self.unchecked_into_f64() as _
    }
}
impl Wire2Api<Vec<u16>> for JsValue {
    fn wire2api(self) -> Vec<u16> {
        self.unchecked_into::<js_sys::Uint16Array>().to_vec().into()
    }
}
impl Wire2Api<Vec<u8>> for JsValue {
    fn wire2api(self) -> Vec<u8> {
        self.unchecked_into::<js_sys::Uint8Array>().to_vec().into()
    }
}

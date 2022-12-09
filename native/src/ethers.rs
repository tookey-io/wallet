use anyhow::Context;
use hex::ToHex;
use rlp::RlpStream;
use serde::{Deserialize, Serialize};
use tookey_libtss::curv::arithmetic::Integer;
use tookey_libtss::curv::elliptic::curves::secp256_k1::Secp256k1Scalar;
use tookey_libtss::curv::elliptic::curves::{ECPoint, ECScalar, Scalar, Secp256k1};
use tookey_libtss::curv::BigInt;
use tookey_libtss::ecdsa::state_machine::keygen::LocalKey;
use tookey_libtss::ethereum_types;
use web3::types::{AccessList, Recovery, U256, U64};
use web3::{
    ethabi::Address,
    signing::keccak256,
    types::{Bytes, H256},
};

pub fn transaction_to_message_hash(tx_request: String) -> anyhow::Result<String> {
    let transaction: Transaction = serde_json::from_str(&tx_request)?;

    let message = transaction.encode(None);
    message_to_hash(String::from("0x") + &hex::encode(message))
}

pub fn message_to_hash(data: String) -> anyhow::Result<String> {
    let message = bytes_from_hex(data)?;
    let message_hash = H256::from(keccak256(&message));

    Ok(String::from("0x") + &message_hash.encode_hex::<String>())
}

pub fn encode_message_sign(data: String, chain_id: u32, signature: String) -> anyhow::Result<String> {
    let mut signature: SignatureRecid = serde_json::from_str(&signature)?;

    sanitize_signature(&mut signature, chain_id);

    let rec = Recovery::new(
        bytes_from_hex(data)?,
        signature.recid,
        H256::from_slice(signature.r.to_bytes().as_ref()),
        H256::from_slice(signature.s.to_bytes().as_ref()),
    );

    let (signature, v) = rec.as_signature().context("failed take signature from recoverable")?;

    let mut slice: [u8; 65] = [0u8; 65];

    slice[..64].copy_from_slice(&signature);
    slice[64] = v as u8;

    Ok(String::from("0x") + &ethereum_types::Signature::from_slice(&slice).encode_hex::<String>())
}

pub fn encode_transaction(tx_request: String, signature: String) -> anyhow::Result<Vec<u8>> {
    let transaction: Transaction = serde_json::from_str(&tx_request)?;
    let mut signature: SignatureRecid = serde_json::from_str(&signature)?;

    sanitize_signature(&mut signature, transaction.chain_id.as_u32());

    let sig = Signature {
        v: signature.recid,
        r: H256::from_slice(&signature.r.to_bytes()),
        s: H256::from_slice(&signature.s.to_bytes()),
    };

    Ok(transaction.encode(Some(&sig)))
}

pub fn to_ethereum_address(key: String) -> anyhow::Result<String> {
    let key: LocalKey<Secp256k1> = serde_json::from_str(&key)?;

    let public_key = key.y_sum_s.as_raw().serialize_uncompressed();

    debug_assert_eq!(public_key[0], 0x04);
    let hash = keccak256(&public_key[1..]);

    Ok(checksum(Address::from_slice(&hash[12..])))
}

fn bytes_from_hex(data: String) -> anyhow::Result<Vec<u8>> {
    let result = if data.starts_with("0x") {
        hex::decode(data.strip_prefix("0x").unwrap())?
    } else {
        hex::decode(data)?
    };

    Ok(result)
}

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct SignatureRecid {
    pub r: Scalar<Secp256k1>,
    pub s: Scalar<Secp256k1>,
    pub recid: u64,
}

fn sanitize_signature(signature: &mut SignatureRecid, chain: u32) {
    let s = signature.s.to_bigint();
    let n = Secp256k1Scalar::group_order().clone();
    let half_n = n.div_floor(&BigInt::from(2));
    if s > half_n {
        let ns = n - s;
        signature.s = Scalar::<Secp256k1>::from(&ns);
    }

    if signature.recid <= 3 {
        signature.recid += (chain as u64) * 2 + 35;
    }
}

/// Gets the checksummed address of a H160 hash
fn checksum(address: Address) -> String {
    let address = format!("{:x}", address);
    let address_hash = format!("{:x}", H256::from(keccak256(address.as_bytes())));

    address
        .char_indices()
        .fold(String::from("0x"), |mut acc, (index, address_char)| {
            let n = u16::from_str_radix(&address_hash[index..index + 1], 16).unwrap();

            if n > 7 {
                // make char uppercase if ith character is 9..f
                acc.push_str(&address_char.to_uppercase().to_string())
            } else {
                // already lowercased
                acc.push(address_char)
            }

            acc
        })
}

const LEGACY_TX_ID: u64 = 0;
const ACCESSLISTS_TX_ID: u64 = 1;
const EIP1559_TX_ID: u64 = 2;

/// A struct that represents the components of a secp256k1 signature.
pub struct Signature {
    /// V component in electrum format with chain-id replay protection.
    pub v: u64,
    /// R component of the signature.
    pub r: H256,
    /// S component of the signature.
    pub s: H256,
}

/// A transaction used for RLP encoding, hashing and signing.
#[derive(Debug, Serialize, Deserialize)]
pub struct Transaction {
    /// Chain ID
    #[serde(rename = "chainId")]
    pub chain_id: U64,
    /// Recipient address (None for contract creation)
    #[serde(skip_serializing_if = "Option::is_none")]
    pub to: Option<Address>,
    /// Transaction nonce
    pub nonce: U256,
    /// Supplied gas
    pub gas: U256,
    /// Gas price
    #[serde(rename = "gasPrice")]
    pub gas_price: U256,
    /// Transfered value
    pub value: U256,
    /// Transaction data
    pub data: Bytes,
    /// Transaction type, Some(1) for AccessList transaction, None for Legacy
    #[serde(rename = "type", default, skip_serializing_if = "Option::is_none")]
    pub transaction_type: Option<U64>,
    /// Access list
    #[serde(rename = "accessList", default)]
    pub access_list: AccessList,
    /// Max fee per gas
    #[serde(rename = "maxFeePerGas", skip_serializing_if = "Option::is_none")]
    pub _max_fee_per_gas: Option<U256>,
    /// miner bribe
    #[serde(rename = "maxPriorityFeePerGas")]
    pub max_priority_fee_per_gas: U256,
}

impl Transaction {
    fn rlp_append_legacy(&self, stream: &mut RlpStream) {
        stream.append(&self.nonce);
        stream.append(&self.gas_price);
        stream.append(&self.gas);
        if let Some(to) = self.to {
            stream.append(&to);
        } else {
            stream.append(&"");
        }
        stream.append(&self.value);
        stream.append(&self.data.0);
    }

    fn encode_legacy(&self, signature: Option<&Signature>) -> RlpStream {
        let mut stream = RlpStream::new();
        stream.begin_list(9);

        self.rlp_append_legacy(&mut stream);

        if let Some(signature) = signature {
            self.rlp_append_signature(&mut stream, signature);
        } else {
            stream.append(&self.chain_id);
            stream.append(&0u8);
            stream.append(&0u8);
        }

        stream
    }

    fn encode_access_list_payload(&self, signature: Option<&Signature>) -> RlpStream {
        let mut stream = RlpStream::new();

        let list_size = if signature.is_some() { 11 } else { 8 };
        stream.begin_list(list_size);

        // append chain_id. from EIP-2930: chainId is defined to be an integer of arbitrary size.
        stream.append(&self.chain_id);

        self.rlp_append_legacy(&mut stream);
        self.rlp_append_access_list(&mut stream);

        if let Some(signature) = signature {
            self.rlp_append_signature(&mut stream, signature);
        }

        stream
    }

    fn encode_eip1559_payload(&self, signature: Option<&Signature>) -> RlpStream {
        let mut stream = RlpStream::new();

        let list_size = if signature.is_some() { 12 } else { 9 };
        stream.begin_list(list_size);

        // append chain_id. from EIP-2930: chainId is defined to be an integer of arbitrary size.
        stream.append(&self.chain_id);

        stream.append(&self.nonce);
        stream.append(&self.max_priority_fee_per_gas);
        stream.append(&self.gas_price);
        stream.append(&self.gas);
        if let Some(to) = self.to {
            stream.append(&to);
        } else {
            stream.append(&"");
        }
        stream.append(&self.value);
        stream.append(&self.data.0);

        self.rlp_append_access_list(&mut stream);

        if let Some(signature) = signature {
            self.rlp_append_signature(&mut stream, signature);
        }

        stream
    }

    fn rlp_append_signature(&self, stream: &mut RlpStream, signature: &Signature) {
        stream.append(&signature.v);
        stream.append(&U256::from_big_endian(signature.r.as_bytes()));
        stream.append(&U256::from_big_endian(signature.s.as_bytes()));
    }

    fn rlp_append_access_list(&self, stream: &mut RlpStream) {
        stream.begin_list(self.access_list.len());
        for access in self.access_list.iter() {
            stream.begin_list(2);
            stream.append(&access.address);
            stream.begin_list(access.storage_keys.len());
            for storage_key in access.storage_keys.iter() {
                stream.append(storage_key);
            }
        }
    }

    pub fn encode(&self, signature: Option<&Signature>) -> Vec<u8> {
        match self.transaction_type.map(|t| t.as_u64()) {
            Some(LEGACY_TX_ID) | None => {
                let stream = self.encode_legacy(signature);
                stream.out().to_vec()
            }

            Some(ACCESSLISTS_TX_ID) => {
                let tx_id: u8 = ACCESSLISTS_TX_ID as u8;
                let stream = self.encode_access_list_payload(signature);
                [&[tx_id], stream.as_raw()].concat()
            }

            Some(EIP1559_TX_ID) => {
                let tx_id: u8 = EIP1559_TX_ID as u8;
                let stream = self.encode_eip1559_payload(signature);
                [&[tx_id], stream.as_raw()].concat()
            }

            _ => {
                panic!("Unsupported transaction type");
            }
        }
    }
}

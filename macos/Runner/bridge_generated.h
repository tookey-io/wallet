#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_TookeyScenarios_KeygenECDSA {
  uint16_t index;
  uint16_t parties;
  uint16_t threashold;
} wire_TookeyScenarios_KeygenECDSA;

typedef struct wire_uint_16_list {
  uint16_t *ptr;
  int32_t len;
} wire_uint_16_list;

typedef struct wire_TookeyScenarios_SignECDSA {
  struct wire_uint_16_list *parties;
  struct wire_uint_8_list *key;
  struct wire_uint_8_list *hash;
} wire_TookeyScenarios_SignECDSA;

typedef union TookeyScenariosKind {
  struct wire_TookeyScenarios_KeygenECDSA *KeygenECDSA;
  struct wire_TookeyScenarios_SignECDSA *SignECDSA;
} TookeyScenariosKind;

typedef struct wire_TookeyScenarios {
  int32_t tag;
  union TookeyScenariosKind *kind;
} wire_TookeyScenarios;

typedef struct wire_IncomingMessage_Begin {
  struct wire_TookeyScenarios *scenario;
} wire_IncomingMessage_Begin;

typedef struct wire_IncomingMessage_Participant {
  uint16_t index;
  uint16_t *party;
} wire_IncomingMessage_Participant;

typedef struct wire_IncomingMessage_Group {
  struct wire_uint_16_list *indexes;
  struct wire_uint_16_list *parties;
} wire_IncomingMessage_Group;

typedef struct wire_IncomingMessage_Communication {
  struct wire_uint_8_list *packet;
} wire_IncomingMessage_Communication;

typedef struct wire_IncomingMessage_Close {

} wire_IncomingMessage_Close;

typedef union IncomingMessageKind {
  struct wire_IncomingMessage_Begin *Begin;
  struct wire_IncomingMessage_Participant *Participant;
  struct wire_IncomingMessage_Group *Group;
  struct wire_IncomingMessage_Communication *Communication;
  struct wire_IncomingMessage_Close *Close;
} IncomingMessageKind;

typedef struct wire_IncomingMessage {
  int32_t tag;
  union IncomingMessageKind *kind;
} wire_IncomingMessage;

typedef struct WireSyncReturnStruct {
  uint8_t *ptr;
  int32_t len;
  bool success;
} WireSyncReturnStruct;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

void wire_to_public_key(int64_t port_, struct wire_uint_8_list *key, bool compressed);

void wire_to_ethereum_address(int64_t port_, struct wire_uint_8_list *key);

void wire_message_to_hash(int64_t port_, struct wire_uint_8_list *message);

void wire_to_ethereum_signature(int64_t port_,
                                struct wire_uint_8_list *message,
                                struct wire_uint_8_list *signature,
                                uint32_t chain);

void wire_connect_logger(int64_t port_);

void wire_get_next_id(int64_t port_);

void wire_initialize(int64_t port_, uint32_t id);

void wire_receive(int64_t port_, uint32_t id, struct wire_IncomingMessage *value);

void wire_to_message_hash(int64_t port_, struct wire_uint_8_list *tx_request);

void wire_convert_to_ethers_signature(int64_t port_,
                                      struct wire_uint_8_list *tx_request,
                                      struct wire_uint_8_list *signature);

void wire_encode_transaction(int64_t port_,
                             struct wire_uint_8_list *tx_request,
                             struct wire_uint_8_list *signature);

void wire_critical__static_method__OutgoingMessage(int64_t port_, struct wire_uint_8_list *message);

void wire_invalid__static_method__OutgoingMessage(int64_t port_, struct wire_uint_8_list *message);

struct wire_IncomingMessage *new_box_autoadd_incoming_message_0(void);

struct wire_TookeyScenarios *new_box_autoadd_tookey_scenarios_0(void);

uint16_t *new_box_autoadd_u16_0(uint16_t value);

struct wire_uint_16_list *new_uint_16_list_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

union IncomingMessageKind *inflate_IncomingMessage_Begin(void);

union IncomingMessageKind *inflate_IncomingMessage_Participant(void);

union IncomingMessageKind *inflate_IncomingMessage_Group(void);

union IncomingMessageKind *inflate_IncomingMessage_Communication(void);

union TookeyScenariosKind *inflate_TookeyScenarios_KeygenECDSA(void);

union TookeyScenariosKind *inflate_TookeyScenarios_SignECDSA(void);

void free_WireSyncReturnStruct(struct WireSyncReturnStruct val);

void store_dart_post_cobject(DartPostCObjectFnType ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_to_public_key);
    dummy_var ^= ((int64_t) (void*) wire_to_ethereum_address);
    dummy_var ^= ((int64_t) (void*) wire_message_to_hash);
    dummy_var ^= ((int64_t) (void*) wire_to_ethereum_signature);
    dummy_var ^= ((int64_t) (void*) wire_connect_logger);
    dummy_var ^= ((int64_t) (void*) wire_get_next_id);
    dummy_var ^= ((int64_t) (void*) wire_initialize);
    dummy_var ^= ((int64_t) (void*) wire_receive);
    dummy_var ^= ((int64_t) (void*) wire_to_message_hash);
    dummy_var ^= ((int64_t) (void*) wire_convert_to_ethers_signature);
    dummy_var ^= ((int64_t) (void*) wire_encode_transaction);
    dummy_var ^= ((int64_t) (void*) wire_critical__static_method__OutgoingMessage);
    dummy_var ^= ((int64_t) (void*) wire_invalid__static_method__OutgoingMessage);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_incoming_message_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_tookey_scenarios_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_u16_0);
    dummy_var ^= ((int64_t) (void*) new_uint_16_list_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) inflate_IncomingMessage_Begin);
    dummy_var ^= ((int64_t) (void*) inflate_IncomingMessage_Participant);
    dummy_var ^= ((int64_t) (void*) inflate_IncomingMessage_Group);
    dummy_var ^= ((int64_t) (void*) inflate_IncomingMessage_Communication);
    dummy_var ^= ((int64_t) (void*) inflate_TookeyScenarios_KeygenECDSA);
    dummy_var ^= ((int64_t) (void*) inflate_TookeyScenarios_SignECDSA);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturnStruct);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    return dummy_var;
}
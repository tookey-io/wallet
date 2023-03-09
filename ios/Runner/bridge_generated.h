#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
typedef struct _Dart_Handle* Dart_Handle;

typedef struct DartCObject DartCObject;

typedef int64_t DartPort;

typedef bool (*DartPostCObjectFnType)(DartPort port_id, void *message);

typedef struct wire_uint_8_list {
  uint8_t *ptr;
  int32_t len;
} wire_uint_8_list;

typedef struct wire_KeygenParams {
  struct wire_uint_8_list *room_id;
  uint16_t participant_index;
  uint16_t participants_count;
  uint16_t participants_threshold;
  struct wire_uint_8_list *relay_address;
  uint16_t timeout_seconds;
} wire_KeygenParams;

typedef struct wire_uint_16_list {
  uint16_t *ptr;
  int32_t len;
} wire_uint_16_list;

typedef struct wire_SignParams {
  struct wire_uint_8_list *room_id;
  struct wire_uint_8_list *key;
  struct wire_uint_8_list *data;
  struct wire_uint_16_list *participants_indexes;
  struct wire_uint_8_list *relay_address;
  uint16_t timeout_seconds;
} wire_SignParams;

typedef struct DartCObject *WireSyncReturn;

void store_dart_post_cobject(DartPostCObjectFnType ptr);

Dart_Handle get_dart_object(uintptr_t ptr);

void drop_dart_object(uintptr_t ptr);

uintptr_t new_dart_opaque(Dart_Handle handle);

intptr_t init_frb_dart_api_dl(void *obj);

void wire_connect_logger(int64_t port_);

void wire_public_key_to_ethereum_address(int64_t port_, struct wire_uint_8_list *public_key);

void wire_private_key_to_public_key(int64_t port_,
                                    struct wire_uint_8_list *private_key,
                                    bool compressed);

void wire_private_key_to_ethereum_address(int64_t port_, struct wire_uint_8_list *private_key);

void wire_transaction_to_message_hash(int64_t port_, struct wire_uint_8_list *tx_request);

void wire_message_to_hash(int64_t port_, struct wire_uint_8_list *data);

void wire_encode_message_signature(int64_t port_,
                                   struct wire_uint_8_list *message_hash,
                                   uint32_t chain_id,
                                   struct wire_uint_8_list *signature_recid);

void wire_encode_transaction(int64_t port_,
                             struct wire_uint_8_list *tx_request,
                             struct wire_uint_8_list *signature_recid);

void wire_keygen(int64_t port_, struct wire_KeygenParams *params);

void wire_sign(int64_t port_, struct wire_SignParams *params);

struct wire_KeygenParams *new_box_autoadd_keygen_params_0(void);

struct wire_SignParams *new_box_autoadd_sign_params_0(void);

struct wire_uint_16_list *new_uint_16_list_0(int32_t len);

struct wire_uint_8_list *new_uint_8_list_0(int32_t len);

void free_WireSyncReturn(WireSyncReturn ptr);

static int64_t dummy_method_to_enforce_bundling(void) {
    int64_t dummy_var = 0;
    dummy_var ^= ((int64_t) (void*) wire_connect_logger);
    dummy_var ^= ((int64_t) (void*) wire_public_key_to_ethereum_address);
    dummy_var ^= ((int64_t) (void*) wire_private_key_to_public_key);
    dummy_var ^= ((int64_t) (void*) wire_private_key_to_ethereum_address);
    dummy_var ^= ((int64_t) (void*) wire_transaction_to_message_hash);
    dummy_var ^= ((int64_t) (void*) wire_message_to_hash);
    dummy_var ^= ((int64_t) (void*) wire_encode_message_signature);
    dummy_var ^= ((int64_t) (void*) wire_encode_transaction);
    dummy_var ^= ((int64_t) (void*) wire_keygen);
    dummy_var ^= ((int64_t) (void*) wire_sign);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_keygen_params_0);
    dummy_var ^= ((int64_t) (void*) new_box_autoadd_sign_params_0);
    dummy_var ^= ((int64_t) (void*) new_uint_16_list_0);
    dummy_var ^= ((int64_t) (void*) new_uint_8_list_0);
    dummy_var ^= ((int64_t) (void*) free_WireSyncReturn);
    dummy_var ^= ((int64_t) (void*) store_dart_post_cobject);
    dummy_var ^= ((int64_t) (void*) get_dart_object);
    dummy_var ^= ((int64_t) (void*) drop_dart_object);
    dummy_var ^= ((int64_t) (void*) new_dart_opaque);
    return dummy_var;
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeySecret _$KeySecretFromJson(Map<String, dynamic> json) => KeySecret(
      json['paillier_dk'],
      json['pk_vec'],
      json['keys_linear'],
      json['paillier_key_vec'],
      json['y_sum_s'],
      json['h1_h2_n_tilde_vec'],
      json['vss_scheme'],
      json['i'] as int,
      json['t'] as int,
      json['n'] as int,
    );

Map<String, dynamic> _$KeySecretToJson(KeySecret instance) => <String, dynamic>{
      'paillier_dk': instance.paillier_dk,
      'pk_vec': instance.pk_vec,
      'keys_linear': instance.keys_linear,
      'paillier_key_vec': instance.paillier_key_vec,
      'y_sum_s': instance.y_sum_s,
      'h1_h2_n_tilde_vec': instance.h1_h2_n_tilde_vec,
      'vss_scheme': instance.vss_scheme,
      'i': instance.i,
      't': instance.t,
      'n': instance.n,
    };

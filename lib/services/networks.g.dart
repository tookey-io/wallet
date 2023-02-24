// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'networks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Network _$NetworkFromJson(Map<String, dynamic> json) => Network(
      name: json['name'] as String,
      website: json['website'] as String?,
      description: json['description'] as String?,
      explorerUrl: json['explorerUrl'] as String?,
      explorerApi: json['explorerApi'] as String?,
      rpc: json['rpc'] as String,
      symbol: json['symbol'] as String,
      assetsSlug: json['assetsSlug'] as String?,
      chainId: json['chainId'] as int,
    );

Map<String, dynamic> _$NetworkToJson(Network instance) => <String, dynamic>{
      'name': instance.name,
      'website': instance.website,
      'description': instance.description,
      'explorerUrl': instance.explorerUrl,
      'explorerApi': instance.explorerApi,
      'rpc': instance.rpc,
      'symbol': instance.symbol,
      'assetsSlug': instance.assetsSlug,
      'chainId': instance.chainId,
    };

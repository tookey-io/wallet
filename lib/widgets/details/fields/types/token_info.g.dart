// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => TokenInfo(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimals: json['decimals'] as int,
      website: json['website'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => LinkInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TokenInfoToJson(TokenInfo instance) => <String, dynamic>{
      'name': instance.name,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'website': instance.website,
      'type': instance.type,
      'status': instance.status,
      'links': instance.links,
    };

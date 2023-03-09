import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tookey/widgets/details/fields/types/link_info.dart';

part 'token_info.g.dart';

@JsonSerializable()
class TokenInfo {
  TokenInfo({
    required this.name,
    required this.symbol,
    required this.decimals,
    this.website,
    this.type,
    this.status,
    this.links,
  });

  factory TokenInfo.fromJsonString(String jsonString) =>
      _$TokenInfoFromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  final String name;
  final String symbol;
  final int decimals;
  final String? website;
  final String? type;
  final String? status;
  final List<LinkInfo>? links;
  
  String? logo;


  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}

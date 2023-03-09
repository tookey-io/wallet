import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'link_info.g.dart';

@JsonSerializable()
class LinkInfo {
  LinkInfo(this.name, this.url);

  final String name;
  final String url;

  factory LinkInfo.fromJsonString(String jsonString) =>
      _$LinkInfoFromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  factory LinkInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LinkInfoToJson(this);

  @override
  String toString() => jsonEncode(toJson());

}
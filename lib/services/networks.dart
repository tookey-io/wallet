// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:web3dart/web3dart.dart';

part 'networks.g.dart';

@JsonSerializable()
class Network {
  Network({
    required this.name,
    this.website,
    this.description,
    this.explorerUrl,
    this.explorerApi,
    required this.rpc,
    required this.symbol,
    this.assetsSlug,
    required this.chainId,
});

  factory Network.fromJsonString(String jsonString) =>
      _$NetworkFromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  factory Network.fromJson(Map<String, dynamic> json) =>
      _$NetworkFromJson(json);

  final String name;
  final String? website;
  final String? description;
  final String? explorerUrl;
  final String? explorerApi;
  final String rpc;
  final String symbol;
  final String? assetsSlug;
  final int chainId;

  static Future<Network> fromSlugAndRpc(String slug, String rpc) async {
    final uri =
        'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/$slug/info/info.json';

    final client = Client();

    final response = await client.get(Uri.parse(uri));

    if (response.statusCode == HttpStatus.ok) {
      final infoData = jsonDecode(response.body);

      final ethClient = Web3Client(rpc, client);

      final rawChainId = await ethClient.getChainId();
      final chainId = rawChainId.toInt();

      return Network(
        name: infoData['name'] as String,
        website: infoData['website'] as String?,
        description: infoData['description'] as String?,
        explorerUrl: infoData['explorer'] as String?,
        explorerApi: infoData['explorer'] as String?,
        rpc: rpc,
        symbol: infoData['symbol'] as String,
        assetsSlug: slug,
        chainId: chainId,
      );
    }

    // ignore: only_throw_errors
    throw 'Not implemented yet';
    // return Network();
  }

  String? get blockchainRootUrl => assetsSlug != null
      ? 'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/$assetsSlug'
      : null;

  String? get logo =>
      blockchainRootUrl != null ? '$blockchainRootUrl/info/logo.png' : null;

  String? tokenUrl(String address) =>
      blockchainRootUrl != null ? '$blockchainRootUrl/assets/$address' : null;

  String? tokenInfoUrl(String address) => blockchainRootUrl != null
      ? '$blockchainRootUrl/assets/$address/info.json'
      : null;

  String? tokenLogoUrl(String address) => blockchainRootUrl != null
      ? '$blockchainRootUrl/assets/$address/logo.png'
      : null;

  String? tokenExplorerUrl(String address) => explorerUrl != null
      ? '$explorerUrl/token/$address'
      : null;
  String? addressExplorerUrl(String address) => explorerUrl != null
      ? '$explorerUrl/address/$address'
      : null;

  Map<String, dynamic> toJson() => _$NetworkToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}

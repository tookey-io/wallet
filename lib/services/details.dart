import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:decimal/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rational/rational.dart';
import 'package:tookey/services/networks.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/src/utils/equality.dart' as eq;
import 'package:web3dart/web3dart.dart';

import '../widgets/details/fields/types/token_info.dart';

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

class TokenAmount {
  TokenAmount({
    required this.raw,
    required this.decimals,
    this.address,
    this.symbol,
    this.icon,
  });

  final BigInt raw;
  final int decimals;
  final String? address;
  final String? symbol;
  final String? icon;

  Decimal get decimalAmount =>
      (Decimal.fromBigInt(raw) / BigInt.from(10).pow(decimals).toDecimal())
          .toDecimal(scaleOnInfinitePrecision: decimals);

  @override
  String toString() => decimalAmount.toString();

  String toHumanString() {
    final integerPart = decimalAmount.floor();
    final fraction = decimalAmount - integerPart;
    final formatter = NumberFormat.decimalPattern('en-US');
    final fractionString = fraction.toString();

    if (fractionString.length > 2) {
      return '${formatter.format(DecimalIntl(integerPart))}.${fractionString.substring(2)}';
    }
    return formatter.format(DecimalIntl(integerPart));
  }

  String toCurrencyString({int? digits}) {
    final formatter = NumberFormat.currency(
      locale: 'en-US',
      decimalDigits: digits ?? decimals,
      name: '',
      symbol: '',
    );
    return formatter.format(DecimalIntl(decimalAmount));
  }
}

class TransactionDetails {
  late final String from;
  late final String to;
  late final int gasLimit;
  late final TokenAmount value;
  late final BigInt gasPrice;
  late final BigInt maxGasPriority;
  late final int nonce;
  late final String data;
}

final EthereumAddress zeroAddress =
    EthereumAddress.fromHex('0x0000000000000000000000000000000000000000');

class TransactionDetailsParser {
  TransactionDetailsParser(this.tx, this.network);

  static final Map<String, Future<String>> _requests = {};
  final WCEthereumTransaction tx;
  final Network network;

  static Future<void> process(
    WCEthereumTransaction tx,
    Network network,
  ) async {
    final instance = TransactionDetailsParser(tx, network);
    await instance._parseTx();
  }

  Future<dynamic> _parseTx() async {
    /* Transaction details service
    *
    * Parse transaction based on incoming raw transaction input:
    * 
    * * Have tx native value? (ETH spending): Show ETH Spend and continue parse
    * * Have tx input data with 0x in recipient?: Show contract creation and stop
    * * Send tx to nonzero recipient: Check is recipient contract? 
    *   -> If non-contract and data isn't zero: Possible fishing? 
              Send tx to EOA with data is unefficient!
    *   -> If contract and data isn't zero: 
    *      -> Check is contract Proxy (getStorageAt(IMPLEMENTATION_SLOT)? 
                Use implementation as recipient of call
    *      -> Request extensed abi
    *         -> If found: Show as smart fields and return
    *      -> Request scan abi (explorerUrl)
    *         -> If found: Show as readable fields and return
    *      -> If abi not found -> Calling unexpected contract (warning) 
    */
    final value = BigInt.parse(tx.value ?? '0');
    final isNativeTransfer = value > BigInt.zero;
    final gasLimit = BigInt.parse(tx.gasLimit ?? '0');
    final isGasMoreThanTransfer = gasLimit > BigInt.from(21000);

    final from = EthereumAddress.fromHex(tx.from);
    final to = tx.to != null ? EthereumAddress.fromHex(tx.to!) : zeroAddress;

    final isSelfTransfer = from == to;
    final dataBuffer = hexToBytes((tx.data ?? '0x').substring(2));
    final isDataEmpty = dataBuffer.isEmpty;
    final recipientSourceCode = await _getSourceCode(to, network);
    final isRecipientContract = recipientSourceCode.isNotEmpty;

    log('isRecipientContract=$isRecipientContract');

    final implementationAddress = isRecipientContract
        ? await _getImplementationAddress(to, network)
        : zeroAddress;

    log('implementationAddress=$implementationAddress');

    final isRecipientProxy = implementationAddress != zeroAddress;
    log('isRecipientProxy=$isRecipientProxy');

    final executionContract = isRecipientProxy ? implementationAddress : to;
    log('executionContract=$executionContract');

    final extendedAbi = isRecipientContract
        ? await _getExtendedAbi(executionContract).catchError((_) => null)
        : null;
    final explorerAbi = isRecipientContract && extendedAbi == null
        ? await _getExplorerAbi(executionContract).catchError((_) => null)
        : null;

    log('extendedAbi: ${extendedAbi != null}');
    log('explorerAbi: ${explorerAbi != null}');

    final abiJson = extendedAbi ?? explorerAbi;

    final contract =
        abiJson != null ? ContractAbi.fromJson(abiJson, 'Contract') : null;

    final callSignature =
        dataBuffer.length >= 4 ? dataBuffer.sublist(0, 4) : null;

    // ignore: omit_local_variable_types
    ContractFunction? contractMethod;
    if (contract != null) {
      for (final element in contract.functions) {
        if (eq.equals(element.selector, callSignature)) {
          contractMethod = element;
          break;
        }
      }
    }

    log('contractMethod=${contractMethod?.name}');

    final buffer = dataBuffer.length > 4 ? dataBuffer.sublist(4) : null;
    final decodedCall = contractMethod != null && buffer != null
        ? TupleType(contractMethod.parameters.map((e) => e.type).toList())
            .decode(
            buffer.buffer,
            0,
          )
        : null;

    log('decodedCall=$decodedCall');

    // parse inputs
    if (contractMethod != null && decodedCall != null) {
      final parsed = <String, dynamic>{};
      await _parseParams(
        'callData',
        decodedCall.data,
        parsed,
        contractMethod.parameters,
      );
    }
  }

  Future<void> _parseParams(
    String prefix,
    List<dynamic> decodedParamsData,
    Map<String, dynamic> parsed,
    List<FunctionParameter<dynamic>> params,
  ) async {
    log('parse $prefix');
    for (var parameter in params) {
      if (parameter is CompositeFunctionParameter) {
        await _parseParams(
          '$prefix.${parameter.name}',
          decodedParamsData,
          parsed,
          parameter.components,
        );
        // tuple struct
      } else {
        final data = decodedParamsData.removeAt(0);
        log('param: ${parameter.name}, data: $data, type: ${parameter.type.name}');
        // abiEncoderV1
        final test = {
          'abiType': {
            'runtime': parameter.type.runtimeType.toString(),
            'internalType': parameter.type.name,
          },
          'meta': parameter.meta,
          'name': parameter.name,
          'rawData': data
        };

        final kind = test['meta']?['kind'] as String?;

        if (kind == 'token' && data is EthereumAddress) {
          test['token'] = await _fetchToken(data);
        }

        parsed['$prefix.${parameter.name}'] = test;
      }
    }
  }

  Future<Uint8List> _getSourceCode(EthereumAddress to, Network network) {
    final web3 = Web3Client(network.rpc, http.Client());
    return web3.getCode(to);
  }

  Future<EthereumAddress> _getImplementationAddress(
    EthereumAddress to,
    Network network,
  ) {
    final ethClient = Web3Client(network.rpc, http.Client());
    return ethClient
        .getStorage(
          to,
          BigInt.parse(
            // _IMPLEMENTATION_SLOT
            '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc',
          ),
        )
        .then((bytes) => EthereumAddress(bytes.sublist(12)));
  }

  Future<String> _getExtendedAbi(
    EthereumAddress executionContract,
  ) {
    return _fetchOrCache(
        'https://raw.githubusercontent.com/tookey-io/extended-abis/main/${network.chainId}/${executionContract.hexEip55}.json');
  }

  Future<String?> _getExplorerAbi(
    EthereumAddress executionContract,
  ) {
    if (network.explorerUrl == null) {
      return Future.value();
    }

    return _fetchOrCache(
            '${network.explorerApi!}/api?module=contract&action=getabi&address=${executionContract.hexEip55}')
        .then((response) => jsonDecode(response)['result'] as String);
  }

  Future<String> _fetchOrCache(String url) {
    if (!_requests.containsKey(url)) {
      _requests[url] = http.get(Uri.parse(url)).then((response) {
        if (response.ok) {
          return response.body;
        }

        throw ErrorDescription('error');
      });
    }

    return _requests[url]!;
  }

  Future<TokenInfo?> _fetchToken(EthereumAddress data) async {
    // 1. try to find on trustassets
    try {
      final trustInfoUri = network.tokenInfoUrl(data.hexEip55);
      final trustLogoUri = network.tokenInfoUrl(data.hexEip55);

      if (trustInfoUri != null && trustLogoUri != null) {
        final tokenInfoJson = await _fetchOrCache(trustInfoUri);
        final tokenInfo = TokenInfo.fromJsonString(tokenInfoJson)
          ..logo = trustLogoUri;

        return tokenInfo;
      }
      // ignore: empty_catches
    } catch (e) {}

    // 2. try to fetch from RPC
  }
}

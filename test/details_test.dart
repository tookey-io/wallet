import 'dart:convert';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tookey/services/details.dart';
import 'package:tookey/services/networks.dart';
import 'package:wallet_connect/wallet_connect.dart';

void main() {
  final mainnet = Network.fromJsonString('''
{
        "name": "Ethereum",
        "website": "https://ethereum.org",
        "description": "Open source platform to write and distribute decentralized applications.",
        "explorerUrl": "https://etherscan.io",
        "explorerApi": "https://api.etherscan.io",
        "rpc": "https://rpc.ankr.com/eth",
        "symbol": "ETH",
        "assetsSlug": "ethereum",
        "chainId": 1
    }
''');
  group('TransactionDetailsParser.process', () {
    test('Simple tx', () async {
      await TransactionDetailsParser.process(
        WCEthereumTransaction.fromJson(
          // ignore: leading_newlines_in_multiline_strings
          jsonDecode('''{
                          "from": "0xdef13e0461bd92f2cd4ffacb947b50a5ab2cc998",
                          "to": "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2",
                          "nonce": "0x1fa",
                          "gasPrice": "0x21d997647e",
                          "maxFeePerGas": "0x2beeb14e6e",
                          "maxPriorityFeePerGas": "0x758b5a469",
                          "gas": "0x493e0",
                          "value": "0x0",
                          "data": "0x617ba037000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000001dcd65000000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000000000000"
                        }''') as Map<String, dynamic>,
        ),
        mainnet,
      );
    });
  });
  group('TokenAmounts', () {
    test('Should be 1 if 10**18', () {
      final amount = TokenAmount(
        decimals: 18,
        raw: BigInt.one * BigInt.from(10).pow(18),
      );

      expect(
        amount.toString(),
        '1',
        reason: 'toString',
      );
      expect(
        amount.toHumanString(),
        '1',
        reason: 'toHumanString',
      );
      expect(
        amount.toCurrencyString(digits: 4),
        '1.0000',
        reason: 'toCurrency',
      );
    });
    test('Should be 1,000 if 1000 * 10**18', () {
      final amount = TokenAmount(
        decimals: 18,
        raw: BigInt.from(1000) * BigInt.from(10).pow(18),
      );

      expect(
        amount.toString(),
        '1000',
        reason: 'toString',
      );
      expect(
        amount.toHumanString(),
        '1,000',
        reason: 'toHumanString',
      );
      expect(
        amount.toCurrencyString(digits: 4),
        '1,000.0000',
        reason: 'toCurrency',
      );
    });

    test('Should be 1,000.05 if 100005 * 10**16', () {
      final amount = TokenAmount(
        decimals: 18,
        raw: BigInt.from(100005) * BigInt.from(10).pow(16),
      );

      expect(
        amount.toString(),
        '1000.05',
        reason: 'toString',
      );
      expect(
        amount.toHumanString(),
        '1,000.05',
        reason: 'toHumanString',
      );
      expect(
        amount.toCurrencyString(digits: 4),
        '1,000.0500',
        reason: 'toCurrency',
      );
    });

    test('Should be 0 if 0.0001', () {
      final amount = TokenAmount(
        decimals: 4,
        raw: BigInt.from(1),
      );

      expect(
        amount.toString(),
        '0.0001',
        reason: 'toString',
      );
      expect(
        amount.toHumanString(),
        '0.0001',
        reason: 'toHumanString',
      );
      expect(
        amount.toCurrencyString(digits: 4),
        '0.0001',
        reason: 'toCurrency',
      );
    });

    test('Should be 0.001 if 0.001', () {
      final amount = TokenAmount(
        decimals: 3,
        raw: BigInt.from(1),
      );

      expect(
        amount.toString(),
        '0.001',
        reason: 'toString',
      );
      expect(
        amount.toHumanString(),
        '0.001',
        reason: 'toHumanString',
      );
      expect(
        amount.toCurrencyString(digits: 4),
        '0.0010',
        reason: 'toCurrency',
      );
    });
  });
}

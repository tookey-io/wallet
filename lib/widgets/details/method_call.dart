
import 'package:web3dart/contracts.dart';

class MethodCall {
  MethodCall({
    required this.method,
    required this.data,
    required this.chainId
  });

  final int chainId;
  final ContractFunction method;
  final List<dynamic> data;

  int get argsCount => method.parameters.length;

  dynamic getArgumentData(int index) => data[index];
  FunctionParameter<dynamic> getArgument(int index) => method.parameters[index];
}
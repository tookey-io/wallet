// This file initializes the dynamic library and connects it with the stub
// generated by flutter_rust_bridge_codegen.
import 'dart:ffi';
import 'dart:io' as io;

import 'package:ffi/ffi.dart';

DynamicLibrary loadLibrary(String base) {
// On MacOS, the dynamic library is not bundled with the binary,
// but rather directly **linked** against the binary.
  final dylib = io.Platform.isWindows ? '$base.dll' : 'lib$base.so';

  return io.Platform.isIOS || io.Platform.isMacOS
      ? DynamicLibrary.executable()
      : DynamicLibrary.open(dylib);
}

typedef __gmpz_add_ui = Pointer<NativeType> Function(Pointer<NativeType> a, Pointer<NativeType> b);
typedef GMPZAddUI = Pointer<NativeType> Function(Pointer<NativeType> a, Pointer<NativeType> b);

final DynamicLibrary gmp = loadLibrary("gmp");

void withMemory<T extends NativeType>(
  int size, void Function(Pointer<T> memory) action) {
  final memory = calloc<Int8>(size);
  try {
    action(memory.cast());
  } finally {
    calloc.free(memory);
  }
}

final GMPZAddUI gmpzAddUiNotExist = gmp.lookup<NativeFunction<__gmpz_add_ui>>("__gmpz_add_not_exist").asFunction();
final GMPZAddUI gmpzAddUi = gmp.lookup<NativeFunction<__gmpz_add_ui>>("__gmpz_add_ui").asFunction();



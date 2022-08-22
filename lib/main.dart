import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rust_bridge_template/pages/wallet_connect.dart';
import 'package:flutter_rust_bridge_template/state.dart';
import 'package:provider/provider.dart';
import 'ffi.dart';
import 'pages/key_list.dart';
import 'sign.dart';
import 'dart:io' as io;

void main() {
  const base = "native";
  final dylib = io.Platform.isWindows ? '$base.dll' : 'lib$base.so';

  final lib = io.Platform.isIOS || io.Platform.isMacOS
      ? DynamicLibrary.executable()
      : DynamicLibrary.open(dylib);

  api = NativeImpl(lib);

  runApp(ChangeNotifierProvider(
    create: ((context) => AppState()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const KeysListPage(title: 'Keys'),
      home: WalletConnect(),
    );
  }
}
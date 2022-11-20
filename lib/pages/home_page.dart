import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../ffi.dart';
import '../sign.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String signerApiUrl =
      dotenv.env['SIGNER_API_URL'] ?? "http://10.0.2.2:8000";

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // These futures belong to the state and are only initialized once,
  // in the initState method.
  Future<String>? signature;

  Future<AbstractSigner>? signer;

  Future<void> signOnline(String hash) async {
    signer = Signer.create(
        widget.signerApiUrl,
        await rootBundle.loadString("assets/shareable-keystore.json"),
        "default-signing");

    await signer?.then((signer) {
      setState(() {
        signature = signer.sign(hash);
      });
    });
  }

  Future<void> signOffline(String hash) async {
    signer = OfflineSigner.create(
        await rootBundle.loadString("assets/owner-keystore.json"),
        await rootBundle.loadString("assets/shareable-keystore.json"));
    await signer?.then((signer) {
      setState(() {
        signature = signer.sign(hash);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Signer"),
            FloatingActionButton(
              onPressed: () => signOffline("hello world"),
              child: const Icon(Icons.explore_off_outlined),
            ),
            FloatingActionButton(
              onPressed: () => signOnline("hello"),
              child: const Icon(Icons.explore_outlined),
            ),

            (signer == null)
                ? const Text("Please init sign process")
                : FutureBuilder<AbstractSigner>(
                    future: signer,
                    builder: (context, snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.none:
                          return const Text("Signer is null");
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return const Text("Signer is initializing...");
                        case ConnectionState.done:
                          if (snap.error != null) {
                            log(snap.error.toString());
                            return Tooltip(
                              message: snap.error.toString(),
                              child:
                                  const Text('Communication has been failed'),
                            );
                          }

                          final data = snap.data;
                          if (data == null) {
                            return const CircularProgressIndicator();
                          }

                          return Text(data.ethereumAddress);
                      }
                    },
                  ),
            // To render the results of a Future, a FutureBuilder is used which
            // turns a Future into an AsyncSnapshot, which can be used to
            // extract the error state, the loading state and the data if
            // available.
            //
            // Here, the generic type that the FutureBuilder manages is
            // explicitly named, because if omitted the snapshot will have the
            // type of AsyncSnapshot<Object?>.
            (signature == null)
                ? const Text("Please init sign process")
                : FutureBuilder<String>(
                    // We await two unrelated futures here, so the type has to be
                    // List<dynamic>.
                    future: signature,
                    builder: (context, snap) {
                      switch (snap.connectionState) {
                        case ConnectionState.none:
                          return const Text("Communication is not initialized");
                        case ConnectionState.waiting:
                          return const Text("Communication is a progress.. ");
                        case ConnectionState.active:
                          return const Text("Unreachable.. ");
                        case ConnectionState.done:
                          if (snap.error != null) {
                            log(snap.error.toString());
                            return Tooltip(
                              message: snap.error.toString(),
                              child:
                                  const Text('Communication has been failed'),
                            );
                          }

                          final data = snap.data;
                          if (data == null) {
                            return const CircularProgressIndicator();
                          }

                          return Text("Connection is ready: $data");
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}

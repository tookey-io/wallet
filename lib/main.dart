import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'client.dart';
import 'ffi.dart';
import 'executor.dart';
import 'sign.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  late Signer signer;
  late Future<Signer> signerInitialization;
  late Future<String> signature;

  Future<Signer> initSigner() async {
    signer = await Signer.create("http://10.0.2.2:8000", await rootBundle.loadString("assets/local-share1.json"), participants: [1,2], room: "default-signing-offline");
    return signer;
  }

  @override
  void initState() {
    signerInitialization = initSigner();
    signature = signerInitialization.then((signer) => signer.sign("hello"));
    super.initState();
  }

  // void startMultiply() {
  //   var rng = math.Random();
  //   var rndId = rng.nextInt(1000000);

  //   setState(() {
  //     complete = false;
  //     id = rndId;
  //     log("Create multiply with id $id");
  //     multiply = api.multiplyIncoming(id: rndId).whenComplete(() => {
  //           setState(() {
  //             complete = true;
  //           })
  //         });

  //     outgoing = api.createOutgoingStream(id: rndId);
  //     outgoing?.listen((event) {
  //       if (id != rndId) {
  //         log("outdated stream");
  //         return;
  //       }

  //       log("Test: $event $rndId $id");
  //       if (event is OutgoingMessage_Multiply) {
  //         setState(() {
  //           lastValue = event.field0;
  //         });
  //         log("Multiply incoming: $lastValue");
  //         api.sendIncoming(
  //             id: rndId, value: IncomingMessage.multiply(event.field0));
  //       }
  //       if (event is OutgoingMessage_Close) {
  //         log("Close channel $rndId");
  //         api.closeOutgoinStream(id: rndId);
  //       }
  //     });
  //   });
  // }

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
            // To render the results of a Future, a FutureBuilder is used which
            // turns a Future into an AsyncSnapshot, which can be used to
            // extract the error state, the loading state and the data if
            // available.
            //
            // Here, the generic type that the FutureBuilder manages is
            // explicitly named, because if omitted the snapshot will have the
            // type of AsyncSnapshot<Object?>.
            FutureBuilder<void>(
              // We await two unrelated futures here, so the type has to be
              // List<dynamic>.
              future: signerInitialization,
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
                        child: const Text('Communication has been failed'),
                      );
                    }
                    // final data = snap.data;
                    // if (data == null) return const CircularProgressIndicator();

                    return const Text("Connection is ready");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

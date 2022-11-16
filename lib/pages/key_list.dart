import 'dart:convert';
import 'dart:developer';

import 'package:flutter_rust_bridge_template/ffi.dart';
import 'package:flutter_rust_bridge_template/keygen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_template/state.dart';
import 'package:provider/provider.dart';

import './key_import.dart';
import './qr_scanner.dart';

enum KeyAddMethod { import, generate }

class KeyGenerationAction {
  Future<String>? _roomId;
  Future<String>? _adminKey;
  Future<String>? _shareableKey;

  KeyGenerationAction();
}

class _KeysListPageState extends State<KeysListPage> {
  KeyGenerationAction? _keygen;

  handleKeyChoice(String id) {
    log("Select key $id");
  }

  Future<String?> _generateKeys(String apiKey) async {
    log("APIKEY: $apiKey");

    var msg = jsonEncode(<String, dynamic>{
      "participantsThreshold": 2,
      "participantsCount": 3,
      "timeoutSeconds": 60,
      "name": "Key 1",
      "description": "Some key",
      "tags": ["shareable"]
    });

    log(msg);

    http.post(Uri.parse("http://10.0.2.2:9001/api/keys"),
        body: msg,
        headers: <String, String>{
          "Content-Type": "application/json",
          "accept": "application/json",
          "apiKey": apiKey
        }).then((answer) async {
      log(answer.body);
      final json = jsonDecode(answer.body);
      final room = json["roomId"].toString();

      log(room);
      final shareableKeygenerator =
          await Keygenerator.create(2, "http://10.0.2.2:8000", room);
      final adminKeygenerator =
          await Keygenerator.create(3, "http://10.0.2.2:8000", room);

      // log(await shareableKeygenerator.keygen());
      final results = await Future.wait(
          [shareableKeygenerator.keygen(), adminKeygenerator.keygen()]);

      log(results[0]);
    });
    showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 15),
                    const Text("Signature progress",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 25),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text("Cancel"))
                  ],
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      primary: Theme.of(context).colorScheme.onPrimary,
    );
    return Consumer<AppState>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            TextButton(
                style: style,
                onPressed: () {
                  state.removeAccessToken();
                },
                child: const Icon(Icons.logout)),
            PopupMenuButton(
                onSelected: (method) {
                  switch (method) {
                    case KeyAddMethod.import:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const KeyImportPage()),
                      );
                      break;
                    default:
                      _generateKeys(state.accessToken!);
                      break;
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<KeyAddMethod>>[
                      const PopupMenuItem<KeyAddMethod>(
                        value: KeyAddMethod.import,
                        child: ListTile(
                            title: Text('Import a key'),
                            leading: Icon(Icons.file_download)),
                      ),
                      const PopupMenuItem<KeyAddMethod>(
                        value: KeyAddMethod.generate,
                        child: ListTile(
                            title: Text('Generate new key'),
                            leading: Icon(Icons.generating_tokens)),
                      ),
                    ],
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: const Icon(Icons.add)))
          ],
        ),
        body: Consumer<AppState>(builder: (context, state, child) {
          if (state.knownKeys.isNotEmpty) {
            return ListView(
                children: state.knownKeys
                    .map((id) => ListTile(
                          key: Key(id),
                          leading: const Icon(Icons.key),
                          title: Text("Key $id"),
                          onTap: () => handleKeyChoice(id),
                        ))
                    .toList());
          } else {
            return Center(
                child: Column(
              children: const [
                Spacer(),
                Icon(Icons.no_sim_outlined, size: 48, color: Colors.grey),
                Padding(padding: EdgeInsets.all(10)),
                Text("Keys not found",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Padding(padding: EdgeInsets.all(5)),
                Text("Consider to generate new one or import existed"),
                Spacer(flex: 2),
                Text(
                  "or use scan QR \nwith connection code",
                  textAlign: TextAlign.center,
                  style: TextStyle(height: 1.3, color: Colors.grey),
                ),
                SizedBox(height: 40)
              ],
            ));
          }
        }),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 45.0),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Scan QR",
          child: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QRScanner(
                        onData: (raw) {
                          log(raw);
                        },
                      )),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }
}

class KeysListPage extends StatefulWidget {
  final String title;

  const KeysListPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeysListPageState();
}

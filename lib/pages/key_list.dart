import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tookey/pages/key_import.dart';
import 'package:tookey/services/wallet_connect/wallet_connect.dart';
import 'package:tookey/state.dart';

enum KeyAddMethod { import, generate }

class _KeysListPageState extends State<KeysListPage> {
  handleKeyChoice(String id) {
    log("Select key $id");
  }

  showModal(String title, String text, Color color) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                const SizedBox(height: 20),
                Icon(Icons.check, color: color),
                const SizedBox(height: 15),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 15),
                Text(text, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 25),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(ctx, null);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: color,
                    ),
                    child: const Text("Ok"))
              ],
            ));
  }

  showSuccess(String title, String text) {
    showModal(title, text, Colors.greenAccent);
  }

  showError(String title, String text) {
    showModal(title, text, Colors.redAccent);
  }

  Future<Keystore?> _generateKeys(AppState state) async {
    Completer<Keystore> keystore = Completer();
    BuildContext? modal;

    keystore.future.then((result) {
      if (modal != null) Navigator.pop(modal!, result);
      showSuccess("Key is done", result.publicKey);
    }).catchError((error) {
      if (modal != null) Navigator.pop(modal!);
      showError(
          "Keygeneration failed", error is String ? error : error.toString());
    });

    showDialog(
        context: context,
        builder: (context) {
          modal = context;
          String? name;
          String? description;
          bool executing = false;

          execute() async {
            executing = true;
            keystore.complete(await state.generateKey(name, description));
          }

          return StatefulBuilder(
              builder: (context, setState) => SimpleDialog(
                    contentPadding: const EdgeInsets.all(20),
                    children: [
                      Column(
                        crossAxisAlignment: executing
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: executing
                            ? [
                                const SizedBox(height: 20),
                                const CircularProgressIndicator(),
                                const SizedBox(height: 15),
                                const Text("Keygeneration progress",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                const SizedBox(height: 25),
                                TextButton(
                                    onPressed: () async {
                                      keystore.completeError("cancel");
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    child: const Text("Cancel"))
                              ]
                            : [
                                const SizedBox(height: 20),
                                const Icon(Icons.edit),
                                const SizedBox(height: 15),
                                const Text("Create new key",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                const SizedBox(height: 15),
                                TextField(
                                  onChanged: (value) => name = value,
                                  decoration:
                                      const InputDecoration(labelText: "Name:"),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  onChanged: (value) => description = value,
                                  decoration: const InputDecoration(
                                      labelText: "Description:"),
                                ),
                                const SizedBox(height: 15),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        log("Name: $name, Desc: $description");
                                        execute();
                                      });
                                    },
                                    child: const Text("Create"))
                              ],
                      )
                    ],
                  ));
        });

    return await keystore.future;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Consumer<AppState>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            TextButton(
                style: style,
                onPressed: () {
                  state.accessToken = null;
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
                      _generateKeys(state);
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
            return ListView(children: [
              ...state.knownKeys
                  .map((key) => ListTile(
                        key: Key(key.publicKey),
                        leading: const Icon(Icons.key),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key.name),
                              Text(key.publicKey,
                                  style: const TextStyle(fontSize: 8))
                            ]),
                        onTap: () {
                          state.shareableKey = key.publicKey;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WalletConnect()));
                        },
                      ))
                  .toList(),
              ...state.availableKeys
                  .where((key) =>
                      !state.knownKeys.map((k) => k.publicKey).contains(key))
                  .map((id) => ListTile(
                        key: Key(id),
                        leading: const Icon(Icons.key_off),
                        title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Unlinked key"),
                              Text(id, style: const TextStyle(fontSize: 8))
                            ]),
                        onTap: () {},
                      ))
            ]);
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
                Spacer(),
                SizedBox(height: 40)
              ],
            ));
          }
        }),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 45.0),
        ),
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_template/state.dart';
import 'package:provider/provider.dart';

import './key_import.dart';
import './qr_scanner.dart';

enum KeyAddMethod { import, generate }

class _KeysListPageState extends State<KeysListPage> {
  handleKeyChoice(String id) {
    log("Select key $id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              onSelected: (method) {
                switch (method) {
                  case KeyAddMethod.import:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const KeyImportPage()),
                    );
                    break;
                  default:
                    const snackBar = SnackBar(
                      content: Text(
                          'Sorry, key generation is unavailable during maintenance... '),
                    );

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class KeysListPage extends StatefulWidget {
  final String title;

  const KeysListPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeysListPageState();
}

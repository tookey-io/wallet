import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/key/key.page.dart';
import 'package:tookey/pages/keys/keys.popup.dart';
import 'package:tookey/state.dart';

class KeysPage extends StatefulWidget {
  const KeysPage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> {
  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              TextButton(
                style: style,
                onPressed: () => state.signout(),
                child: const Icon(Icons.logout),
              ),
              const KeysPopup(),
            ],
          ),
          body: Consumer<AppState>(
            builder: (context, state, child) {
              if (state.knownKeys.isNotEmpty) {
                return ListView(
                  children: [
                    ...state.knownKeys.map(
                      (key) => ListTile(
                        key: Key(key.publicKey),
                        leading: const Icon(Icons.key),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key.name),
                            Text(
                              key.publicKey,
                              style: const TextStyle(fontSize: 8),
                            )
                          ],
                        ),
                        onTap: () {
                          state.shareableKey = key.publicKey;

                          Navigator.push(
                            context,
                            MaterialPageRoute<KeyPage>(
                              builder: (context) => KeyPage(keyRecord: key),
                            ),
                          );
                        },
                      ),
                    ),
                    ...state.availableKeys
                        .where(
                          (key) => !state.knownKeys
                              .map((k) => k.publicKey)
                              .contains(key),
                        )
                        .map(
                          (id) => ListTile(
                            key: Key(id),
                            leading: const Icon(Icons.key_off),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Unlinked key'),
                                Text(id, style: const TextStyle(fontSize: 8))
                              ],
                            ),
                            onTap: () {},
                          ),
                        )
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      Spacer(),
                      Icon(Icons.no_sim_outlined, size: 48, color: Colors.grey),
                      Padding(padding: EdgeInsets.all(10)),
                      Text(
                        'Keys not found',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(5)),
                      Text('Consider to generate new one or import existed'),
                      Spacer(),
                      SizedBox(height: 40)
                    ],
                  ),
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 45),
          ),
        );
      },
    );
  }
}

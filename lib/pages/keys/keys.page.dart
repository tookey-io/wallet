import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/key/key.page.dart';
import 'package:tookey/pages/keys/keys.popup.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/state.dart';

import '../../widgets/toaster.dart';

class KeysPage extends StatefulWidget {
  const KeysPage({super.key, required this.title});
  final String title;

  @override
  State<StatefulWidget> createState() => _KeysPageState();
}

class _KeysPageState extends State<KeysPage> {
  Future<List<KeyRecord>> fetchKeys() async {
    final state = Provider.of<AppState>(context);
    await state.fetchKeys();
    return state.knownKeys;
  }

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
                child: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
              const KeysPopup(),
            ],
          ),
          body: FutureBuilder(
            future: fetchKeys(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data != null) {
                return ListView(
                  children: [
                    ListTile(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(
                              text: state.refreshToken?.token ?? 'N/A'),
                        );
                        await Toaster.success(
                          'Refresh token copied to clipboard',
                        );
                      },
                      key: const Key('refreshToken'),
                      title: Text(state.refreshToken?.token ?? 'N/A'),
                    ),
                    ...state.knownKeys.map(
                      (key) => ListTile(
                        key: Key(key.publicKey),
                        leading: const Icon(Icons.key),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key.name),
                            if (key.description.isNotEmpty)
                              Text(
                                key.description,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white60,
                                ),
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
                    ...state.unknownKeys.map(
                      (key) => ListTile(
                        key: Key(key.publicKey),
                        leading: const Icon(Icons.key_off),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(key.name),
                            if (key.description.isNotEmpty)
                              Text(
                                key.description,
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white60,
                                ),
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
          // bottomNavigationBar: BottomAppBar(
          //   shape: const CircularNotchedRectangle(),
          //   child: Container(height: 45),
          // ),
        );
      },
    );
  }
}

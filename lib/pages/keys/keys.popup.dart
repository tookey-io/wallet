import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/keys/key_import.dialog.dart';
import 'package:tookey/pages/keys/keygen.dialog.dart';
import 'package:tookey/state.dart';

enum KeysPopupAction { import, generate }

class KeysPopup extends StatelessWidget {
  const KeysPopup({super.key});

  Future<void> _showImportKeyDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const KeyImportDialog(),
    );
  }

  Future<Keystore?> _showKeygenDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const KeygenDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        return PopupMenuButton(
          onSelected: (method) {
            switch (method) {
              case KeysPopupAction.import:
                _showImportKeyDialog(context);
                break;
              default:
                _showKeygenDialog(context);
                break;
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<KeysPopupAction>>[
            const PopupMenuItem<KeysPopupAction>(
              value: KeysPopupAction.import,
              child: ListTile(
                title: Text('Import a key'),
                leading: Icon(Icons.file_download),
              ),
            ),
            const PopupMenuItem<KeysPopupAction>(
              value: KeysPopupAction.generate,
              child: ListTile(
                title: Text('Generate new key'),
                leading: Icon(Icons.generating_tokens),
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(15),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

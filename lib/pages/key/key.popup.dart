import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/state.dart';

enum KeyPopupAction { share }

class KeyPopup extends StatelessWidget {
  const KeyPopup({super.key});

  Future<void> _shareKey(AppState state) async {
    await state.shareKey(subject: 'Share key');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return PopupMenuButton(
        onSelected: (method) {
          switch (method) {
            case KeyPopupAction.share:
              _shareKey(state);
              break;
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<KeyPopupAction>>[
          const PopupMenuItem<KeyPopupAction>(
            value: KeyPopupAction.share,
            child: ListTile(
              title: Text('Share key'),
              leading: Icon(Icons.download),
            ),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.all(15),
          child: const Icon(Icons.more_horiz_outlined),
        ),
      );
    });
  }
}

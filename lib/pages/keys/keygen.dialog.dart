import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/keys/keygen_form.dialog.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/dialog/dialog_progress.dart';

class KeygenDialog extends StatefulWidget {
  const KeygenDialog({super.key});

  @override
  State<KeygenDialog> createState() => _KeygenDialogState();
}

class _KeygenDialogState extends State<KeygenDialog> {
  Completer<Keystore?> keystore = Completer<Keystore?>();
  bool isExecuting = false;
  String? name;
  String? description;

  Future<void> _onSubmit(AppState state) async {
    if (keystore.isCompleted) keystore = Completer<Keystore?>();
    if (isExecuting) return;

    setState(() {
      isExecuting = true;
    });

    try {
      final keys = await state.generateKey(name, description);
      keystore.complete(keys[0]);
      await _successDialog(keys[1]);
    } catch (error) {
      if (!keystore.isCompleted) keystore.complete();
      if (!mounted) return;
      if (error is BackendException) {
        await _errorDialog(error.message);
      } else {
        await _errorDialog(error is String ? error : error.toString());
      }
    }

    setState(() {
      isExecuting = false;
    });
  }

  Future<void> _onCancel() async {
    if (!keystore.isCompleted) keystore.complete();
    await _errorDialog('Cancelled');
  }

  Future<void> _successDialog(Keystore adminKey) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        children: [
          Consumer<AppState>(
            builder: (context, state, child) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'Key created',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    adminKey.publicKey,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 25),
                  DialogButton(
                    title: 'SAVE A BACKUP',
                    onPressed: () async {
                      await state.shareKey(
                        key: adminKey.shareableKey,
                        name: adminKey.publicKey,
                      );
                      if (mounted) {
                        Navigator.pop(context);
                        Navigator.pop(ctx);
                      }
                    },
                    buttonStyle: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _errorDialog(String text) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Row(
            children: const [
              Icon(Icons.close, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                'Keygeneration failed',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(text, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 25),
          DialogButton(
            title: 'OK',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(ctx);
            },
            buttonStyle: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      children: [
        Consumer<AppState>(
          builder: (context, state, child) {
            if (isExecuting) {
              return DialogProgress(
                title: 'Keygeneration progress',
                onCancel: _onCancel,
              );
            }

            return KeygenFormDialog(
              onSubmit: () => _onSubmit(state),
              onNameChange: (value) => name = value,
              onDescriptionChange: (value) => description = value,
            );
          },
        )
      ],
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/toaster.dart';

class KeyImportDialog extends StatefulWidget {
  const KeyImportDialog({super.key});

  @override
  State<KeyImportDialog> createState() => _KeyImportDialogState();
}

class _KeyImportDialogState extends State<KeyImportDialog> {
  File? _file;
  bool _isExecuting = true;

  Future<void> _pickFiles() async {
    if (!mounted) return;
    _resetState();
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => log(status.toString()),
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final keyFile = File(result.files.single.path!);
        log(keyFile.path);
        log(keyFile.absolute.path);

        setState(() {
          _isExecuting = false;
          _file = keyFile.absolute;
        });
      } else {
        await Toaster.error('Unable to load file');
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
    // setState(() {
    //   _isExecuting = false;
    //   _fileName =
    //       _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    // });
  }

  void _resetState() {
    if (!mounted) return;
    setState(() {
      _isExecuting = true;
      _file = null;
    });
  }

  void _logException(String message) {
    log(message);
    Toaster.error(message);
  }

  Future<void> _importKey(AppState state) async {
    log('_importKey');

    log(_file?.path ?? 'no file');

    if (_file == null) return;

    final key = await _file?.readAsString();
    if (key != null) {
      final publicKey = await state.importKey(key);
      log(publicKey);
      await _successDialog(publicKey);
    } else {
      log('no key data');
    }
  }

  Future<void> _successDialog(String text) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),
          Row(
            children: const [
              Icon(Icons.check, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Key imported',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isExecuting && _file == null) _pickFiles();
    if (!_isExecuting && _file == null) Navigator.pop(context);

    return SimpleDialog(
      title: Column(
        children: const [
          Text(
            'Key Import',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            if (_file != null)
              Text(_file!.path)
            else
              const CircularProgressIndicator(),
            const SizedBox(height: 15),
            const SizedBox(height: 25),
            Consumer<AppState>(
              builder: (context, state, child) {
                return Row(
                  children: [
                    DialogButton(
                      title: 'IMPORT',
                      onPressed: () => _importKey(state),
                      buttonStyle: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      expanded: true,
                    ),
                    const SizedBox(width: 16),
                    DialogButton(
                      title: 'CANCEL',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      expanded: true,
                    ),
                  ],
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

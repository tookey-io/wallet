import 'dart:developer';

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
  List<PlatformFile>? _paths;
  String? _fileName;
  bool _isExecuting = true;

  Future<void> _pickFiles() async {
    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        onFileLoading: (FilePickerStatus status) => log(status.toString()),
        allowedExtensions: ['json'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation ${e.toString()}');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isExecuting = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
    });
  }

  void _resetState() {
    if (!mounted) return;
    setState(() {
      _isExecuting = true;
      _fileName = null;
      _paths = null;
    });
  }

  void _logException(String message) {
    log(message);
    Toaster.error(message);
  }

  Future<void> _importKey(AppState state) async {
    log('_importKey');

    if (_paths == null) return;

    final key = await rootBundle.loadString(_paths!.first.path!);
    await state.importKey(key);

    await _successDialog(_fileName!);
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
    if (_isExecuting && _fileName == null) _pickFiles();
    if (!_isExecuting && _fileName == '...') Navigator.pop(context);

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
            if (_fileName != null)
              Text(_fileName!)
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

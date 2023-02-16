import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';

import '../state.dart';

class ExportKeyDialog extends StatefulWidget {
  const ExportKeyDialog({
    super.key,
    this.keyData,
    this.name,
    this.subject,
    this.doubleClick,
  });

  final String? keyData;
  final String? name;
  final String? subject;
  final bool? doubleClick;

  @override
  State<ExportKeyDialog> createState() => _ExportKeyDialogState();
}

class _ExportKeyDialogState extends State<ExportKeyDialog> {
  bool _firstTime = true;
  bool _exporting = false;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(20),
      children: [
        Consumer<AppState>(
          builder: (ctx, state, child) => Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  Icon(Icons.ios_share, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Export owner key',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                _firstTime
                    // ignore: lines_longer_than_80_chars
                    ? 'Export your owner key to a safe and private location. Access to the owner key will be necessary for recovery or changing permissions.'
                    // ignore: lines_longer_than_80_chars
                    : "Have you saved it? Click 'Saved' if yes, or export again. We will then remove it from the application.",
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 25),
              Row(
                children: _firstTime
                    ? [
                        DialogButton(
                          title: !_exporting ? 'Save' : '...',
                          expanded: true,
                          onPressed: () async {
                            if (_exporting) return;

                            setState(() {
                              _exporting = true;
                            });

                            await state.shareKey(
                              key: widget.keyData,
                              name: widget.name,
                              subject: widget.subject,
                            );

                            setState(() {
                              _exporting = false;
                              _firstTime = false;
                            });

                            log('click save');
                          },
                        )
                      ]
                    : [
                        DialogButton(
                            title: 'Saved',
                            expanded: true,
                            onPressed: () {
                              log('clicked stored');
                              Navigator.pop(context);
                            }),
                        DialogButton(
                            title: 'Again',
                            expanded: true,
                            onPressed: () async {
                              setState(() {
                                _exporting = true;
                              });

                              await state.shareKey(
                                key: widget.keyData,
                                name: widget.name,
                                subject: widget.subject,
                              );

                              setState(() {
                                _exporting = false;
                              });
                            }),
                      ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
// ignore: always_use_package_imports
import 'dialog_button.dart';

class DialogProgress extends StatelessWidget {
  const DialogProgress({
    super.key,
    required this.title,
    required this.onCancel,
  });

  final String title;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 45),
        const CircularProgressIndicator(),
        const SizedBox(height: 25),
        DialogButton(title: 'CANCEL', onPressed: onCancel),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';

class KeygenFormDialog extends StatefulWidget {
  const KeygenFormDialog({
    super.key,
    required this.onSubmit,
    required this.onNameChange,
    required this.onDescriptionChange,
  });

  final void Function() onSubmit;
  final void Function(String? value) onNameChange;
  final void Function(String? value) onDescriptionChange;

  @override
  State<KeygenFormDialog> createState() => _KeygenFormDialogState();
}

class _KeygenFormDialogState extends State<KeygenFormDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.edit),
        const SizedBox(height: 15),
        const Text(
          'Create new key',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 15),
        TextField(
          onChanged: (value) => widget.onNameChange(value),
          decoration: const InputDecoration(labelText: 'Name:'),
        ),
        const SizedBox(height: 15),
        TextField(
          onChanged: (value) => widget.onDescriptionChange(value),
          decoration: const InputDecoration(labelText: 'Description:'),
        ),
        const SizedBox(height: 15),
        DialogButton(title: 'CREATE', onPressed: widget.onSubmit)
      ],
    );
  }
}

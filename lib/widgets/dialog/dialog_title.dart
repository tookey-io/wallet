import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle({
    super.key,
    required this.icon,
    required this.title,
  });

  final String? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (icon != null)
          Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.network(icon!),
          ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            height: 48,
            width: 48,
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.network(
              icon!,
              errorBuilder: (context, error, stackTrace) =>
                  SvgPicture.network(icon!),
            ),
          ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.buttonStyle,
    this.expanded,
  });

  final String title;
  final void Function()? onPressed;
  final ButtonStyle? buttonStyle;
  final bool? expanded;

  @override
  Widget build(BuildContext context) {
    final button = TextButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(title),
    );
    return expanded != true ? button : Expanded(child: button);
  }
}

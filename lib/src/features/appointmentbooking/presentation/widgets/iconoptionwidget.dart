import 'package:flutter/material.dart';

class Iconoptionwidget extends StatelessWidget {
  const Iconoptionwidget(
      {super.key, required this.text, required this.icon, this.onPressed});
  final String text;
  final Icon icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: icon,
          ),
          Text(text)
        ],
      ),
    );
  }
}

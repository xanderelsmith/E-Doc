import 'package:flutter/material.dart';

class PostTag extends StatelessWidget {
  const PostTag({required this.onTap, required this.label, super.key});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Chip(
      onDeleted: onTap,
      label: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

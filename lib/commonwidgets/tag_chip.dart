import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip(
      {required this.onTap,
      required this.label,
      this.color,
      this.backgroundcolor,
      this.disableIcon = false,
      super.key});
  final String label;
  final VoidCallback onTap;
  final bool disableIcon;
  final Color? color;
  final Color? backgroundcolor;

  @override
  Widget build(BuildContext context) {
    return Chip(
      onDeleted: onTap,
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      surfaceTintColor: color,
      color: WidgetStateProperty.resolveWith(
        (states) => backgroundcolor,
      ),
      deleteIcon: disableIcon ? const SizedBox() : null,
      label: Text(
        label,
        style: TextStyle(fontSize: 14, color: color),
      ),
    );
  }
}

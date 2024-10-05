import 'package:flutter/material.dart';

class BulletPointTextWidget extends StatelessWidget {
  const BulletPointTextWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Icon(
            Icons.circle,
            size: 5,
          ),
        ),
        Text(text)
      ],
    );
  }
}

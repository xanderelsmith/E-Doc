import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/styles/apptextstyles.dart';

class BioDataTile extends StatelessWidget {
  const BioDataTile({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Apptextstyles.smalltextStyle14.grey,
          ),
          Text(
            content,
            style: Apptextstyles.smalltextStyle14,
          ),
        ],
      ),
    );
  }
}

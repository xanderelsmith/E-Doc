import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';

import '../../../../../../styles/apptextstyles.dart';
import '../../../../../../theme/appcolors.dart';
import '../../../../authentication/data/models/specialist.dart';

class DocumentTab extends StatelessWidget {
  const DocumentTab({
    super.key,
    required this.user,
  });
  final Specialist user;
  @override
  Widget build(BuildContext context) {
    var nameList = user.name.split(' ');
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Certificate',
            style: Apptextstyles.smalltextStyle14.grey,
          ),
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: AppColors.grey,
          ),
          Text(
            'Practicing License',
            style: Apptextstyles.smalltextStyle14.grey,
          ),
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: AppColors.grey,
          ),
          Text(
            'Registration certificate',
            style: Apptextstyles.smalltextStyle14.grey,
          ),
          Container(
            height: 20,
            margin: const EdgeInsets.symmetric(vertical: 5),
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthai/theme/appcolors.dart';

import '../src/features/onboarding/presentation/pages/onboardingscreen.dart';

class ExpandedStyledButton extends StatelessWidget {
  const ExpandedStyledButton({
    super.key,
    required this.onTap,
    required this.title,
  });
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(getScreenSize(context).width - 50, 20),
      ),
      child: Text(title),
    );
  }
}

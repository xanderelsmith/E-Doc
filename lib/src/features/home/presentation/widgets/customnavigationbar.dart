import 'package:flutter/material.dart';

import '../../../../../theme/appcolors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final Color selectedColor;
  final bool enableFeedback;
  final Function(int index) onTap;
  final TextStyle? selectedLabelStyle;
  const CustomBottomNavigationBar(
      {super.key,
      required this.onTap,
      required this.enableFeedback,
      required this.items,
      required this.currentIndex,
      this.selectedLabelStyle,
      required this.selectedColor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) => TextButton(
              style: TextButton.styleFrom(
                backgroundColor: currentIndex == index
                    ? AppColors.listTileColor.withOpacity(0.1)
                    : Colors.transparent,
                foregroundColor: AppColors.listTileColor,
              ),
              onPressed: () {
                onTap(index);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  items[index].icon,
                  if (items[index].label != null && currentIndex == index)
                    Text(
                      items[index].label!,
                      style: Theme.of(context)
                          .bottomNavigationBarTheme
                          .selectedLabelStyle,
                    ),
                ],
              ),
            ),
          ),
        ));
  }
}

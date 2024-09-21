import 'package:flutter/material.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/home/presentation/widgets/customnavigationbar.dart';
import 'package:healthai/src/features/home/presentation/widgets/homepagebody.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:intl/intl.dart';

import '../../../../../theme/appcolors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BottomNavPages bottomNavPage = BottomNavPages.home;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 145,
          actions: [
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.casualPink,
              ),
              splashColor: AppColors.casualPink,
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
            )
          ],
          leading: Card(
            margin: const EdgeInsets.only(left: 8, top: 8),
            color: AppColors.casualPink,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: SizedBox(
              width: 141,
              height: 40,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CircleAvatar(
                      radius: 16,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning',
                          style: Apptextstyles.smalltextStyle13
                              .copyWith(fontSize: 12),
                        ),
                        Text(
                          'James Jay',
                          style: Apptextstyles.smalltextStyle13.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: const HomePageBody(),
        bottomNavigationBar: CustomBottomNavigationBar(
          items: BottomNavPages.values
              .map((e) => BottomNavigationBarItem(
                    icon: Icon(
                      e.icon,
                      color: e == bottomNavPage
                          ? AppColors.listTileColor
                          : const Color.fromARGB(255, 71, 68, 68),
                    ),
                    label: e.name,
                  ))
              .toList(),
          onTap: (int index) {
            setState(() {
              bottomNavPage = BottomNavPages.values[index];
            });
          },
          enableFeedback: false,
          currentIndex: bottomNavPage.index,
          selectedColor: AppColors.listTileColor,
        ));
  }
}

enum BottomNavPages {
  home('Home', Icons.house_outlined),
  appointment('Appointment', Icons.calendar_today_outlined),
  settings('Settings', Icons.settings_outlined);

  const BottomNavPages(this.name, this.icon);
  final IconData icon;
  final String name;
}

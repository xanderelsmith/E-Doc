import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/main.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/widgets/customnavigationbar.dart';
import 'package:healthai/src/features/home/presentation/widgets/homepagebody.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../theme/appcolors.dart';
import '../../../profilepage/presentation/pages/profilepage.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    var email = FirebaseAuth.instance.currentUser!.email;
    loadUserData(email, ref);
    super.initState();
  }

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
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ));
            },
            child: Card(
              margin: const EdgeInsets.only(left: 8, top: 8),
              color: AppColors.casualPink,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
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
                      child: Consumer(builder: (context, ref, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning',
                              style: Apptextstyles.smalltextStyle13
                                  .copyWith(fontSize: 12),
                            ),
                            if (ref.watch(userDetailsProvider) is Patient)
                              Text(
                                (ref.watch(userDetailsProvider)! as Patient)
                                    .name
                                    .split(' ')[0]
                                    .toUpperCase(),
                                style: Apptextstyles.smalltextStyle13.bold,
                              ),
                            if (ref.watch(userDetailsProvider) is Specialist)
                              Text(
                                (ref.watch(userDetailsProvider)! as Specialist)
                                    .name
                                    .split(' ')[0]
                                    .toUpperCase(),
                                style: Apptextstyles.smalltextStyle13.bold,
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
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

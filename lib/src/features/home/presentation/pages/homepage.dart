import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/main.dart';
import 'package:healthai/service/notificationservice.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/widgets/iconoptionwidget.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/home/presentation/pages/homebody/patienthomepagebody.dart';
import 'package:healthai/src/features/home/presentation/pages/homebody/specialisthomepagebody.dart';
import 'package:healthai/src/features/home/presentation/pages/specialisthomescreenbody.dart';
import 'package:healthai/src/features/home/presentation/widgets/customnavigationbar.dart';
import 'package:healthai/src/features/home/presentation/widgets/patienthomepagebody.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../theme/appcolors.dart';

import '../../../profilepage/presentation/pages/patient/edit_patient_profilepage.dart';
import '../../../profilepage/presentation/pages/profile_page.dart';
import '../widgets/patientbottomsheet.dart';
import '../widgets/specialistdrawer.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static String id = 'HomePage';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    LocalNotificationService().notificationHandler();
    var email = FirebaseAuth.instance.currentUser!.email;
    loadUserData(email, ref).then(
      (value) {
        LocalNotificationService().uploadFCMToken(value!['email']);
      },
    );
    super.initState();
  }

  BottomNavPages bottomNavPage = BottomNavPages.home;
  @override
  Widget build(BuildContext maincontext) {
    CustomUserData? user = ref.watch(userDetailsProvider);

    return Scaffold(
        endDrawer: const SpecialistDrawer(),
        appBar: AppBar(
          leadingWidth: 180,
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
              if (user != null) {
                context.pushNamed(ProfilePage.id, extra: user);
              }
            },
            child: Card(
              margin: const EdgeInsets.only(left: 8, top: 8),
              color: AppColors.casualPink,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: SizedBox(
                width: 141,
                height: 30,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 16,
                        child: CachedNetworkImage(
                          imageUrl: user != null ? user.profileImageUrl : "",
                          imageBuilder: (context, imageProvider) => ClipOval(
                              child: Image(
                            image: imageProvider,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          )),
                          errorWidget: (context, url, error) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateTime.now().greeting,
                            style: Apptextstyles.smalltextStyle13
                                .copyWith(fontSize: 12),
                          ),
                          if (user is Patient)
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: user == null
            ? const Center(child: CircularProgressIndicator())
            : user.isSpecialist
                ? GetSpecialistHomeScreenBody(
                    index: bottomNavPage.index,
                    user: user as Specialist,
                  )
                : GetPatientHomeScreenBody(
                    index: bottomNavPage.index, patient: user as Patient),
        bottomNavigationBar: Builder(builder: (context) {
          return CustomBottomNavigationBar(
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
              if (bottomNavPage.index != index && index < 2) {
                setState(() {
                  bottomNavPage = BottomNavPages.values[index];
                });
              } else if (user!.isSpecialist &&
                  index == BottomNavPages.settings.index) {
                Scaffold.of(context).openEndDrawer();
              } else if (!user.isSpecialist) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => PatientOptionBottomSheet(
                    patient: user as Patient,
                  ),
                );
              }
            },
            enableFeedback: false,
            currentIndex: bottomNavPage.index,
            selectedColor: AppColors.listTileColor,
          );
        }));
  }
}

enum BottomNavPages {
  home('Home', Icons.house_outlined),
  appointment('Appointment', Icons.calendar_today_outlined),
  settings('Settings', Icons.menu);

  const BottomNavPages(this.name, this.icon);
  final IconData icon;
  final String name;
}

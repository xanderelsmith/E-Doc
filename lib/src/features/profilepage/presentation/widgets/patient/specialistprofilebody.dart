import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/src/features/profilepage/presentation/widgets/specialist/documenttb.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../styles/apptextstyles.dart';
import '../../../../../../theme/appcolors.dart';
import '../../pages/specialist/edit_specialist_profilepage.dart';
import '../specialist/specialist_biodatatab.dart';

class SpecialistProfileBody extends ConsumerStatefulWidget {
  const SpecialistProfileBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientProfileBodyState();
}

class _PatientProfileBodyState extends ConsumerState<SpecialistProfileBody>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Specialist specialist;
  List<Timestamp> count = [];
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this)
      ..addListener(
        () {
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    specialist = ref.watch(userDetailsProvider) as Specialist;
    count = specialist.availableTime ?? [];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff4B17A1),
                              Color(0xffB75CFF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          )),
                      height: 112,
                    ),
                  ),
                  Align(
                    alignment: const Alignment(0, 1),
                    child: CachedNetworkImage(
                      imageUrl: specialist.profileImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 87,
                        width: 87,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      errorWidget: (context, url, error) => Container(
                          height: 87,
                          width: 87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          )),
                      fit: BoxFit.cover,
                      height: 87,
                      width: 87,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Center(
                child: Text(
                  specialist.name ?? "",
                  style: Apptextstyles.smalltextStyle14.w500,
                ),
              ),
            ),
            Center(
              child: Text(
                specialist.email,
                style: Apptextstyles.smalltextStyle14.grey,
              ),
            ),
            Center(
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'EDIT',
                    style: Apptextstyles.normaltextStyle15.bold
                        .copyWith(color: AppColors.primaryColorblue),
                  ),
                ),
                onTap: () {
                  context.pushNamed(EditSpecialistProfilePage.id,
                      extra: specialist);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: TabBar.secondary(
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: const EdgeInsets.all(5),
                indicatorPadding: const EdgeInsets.all(0),
                tabs: [
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      width: 2,
                      color: AppColors.emailgrey,
                    ))),
                    child: const Text('Bio-Data'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                      width: 2,
                      color: AppColors.emailgrey,
                    ))),
                    child: const Text('Document'),
                  ),
                  const Text('Calender')
                ],
                controller: tabController,
                enableFeedback: false,
                labelStyle:
                    Apptextstyles.smalltextStyle14.w500.copyWith(fontSize: 15),
                indicatorColor: Colors.transparent,
              ),
            ),
            IndexedStack(
              index: tabController.index,
              alignment: Alignment.topLeft,
              children: [
                SpecialistBiodataTab(
                  user: specialist,
                ),
                DocumentTab(
                  user: specialist,
                ),
                SpecialistCalenderTab(
                  count: count
                      .map(
                        (e) => e.toDate(),
                      )
                      .toList(),
                  onSelect: (List<DateTime> dates) {
                    setState(() {
                      count = dates
                          .map(
                            (e) => Timestamp.fromDate(e),
                          )
                          .toList();
                    });

                    ref
                        .watch(userDetailsProvider.notifier)
                        .assignUser(specialist.copyWith(availableTime: count));
                  },
                  onUpdate: () async {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );
                    ref
                        .watch(userDetailsProvider.notifier)
                        .assignUser(specialist);
                    await updateUserToFirestore(specialist).then(
                      (value) {
                        if (!context.mounted) return;
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.primaryColorblue,
                            content: Text('Availabity Data Updated ',
                                style: Apptextstyles.normaltextStyle15.bold
                                    .copyWith(color: Colors.white)),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SpecialistCalenderTab extends StatelessWidget {
  const SpecialistCalenderTab({
    super.key,
    required this.onSelect,
    required this.count,
    required this.onUpdate,
  });
  final List<DateTime> count;
  final Function(List<DateTime> dates) onSelect;
  final VoidCallback onUpdate;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          alignment: const Alignment(-0.8, 0),
          width: getScreenSize(context).width,
          color: const Color(0xffF0F9FF),
          child: Text(
            'Mark the dates you wont be available (${count.length})',
            style: Apptextstyles.smalltextStyle14,
          ),
        ),
        CalendarDatePicker2(
          onValueChanged: (value) {
            onSelect(value);
          },
          value: count,
          config: CalendarDatePicker2Config(
              dayBuilder: (
                      {required date,
                      decoration,
                      isDisabled,
                      isSelected,
                      isToday,
                      textStyle}) =>
                  CircleAvatar(
                    backgroundColor: isSelected!
                        ? AppColors.primaryColorblue
                        : Colors.transparent,
                    foregroundColor:
                        isSelected ? AppColors.white : AppColors.emailgrey,
                    child: Text(
                      date.day.toString(),
                      style: Apptextstyles.smalltextStyle13,
                    ),
                  ),
              calendarType: CalendarDatePicker2Type.multi),
        ),
        const Text('Set Consultation Fee (7% as platform fee)'),
        Text(
          'N10,400',
          style: Apptextstyles.normaltextStyle17.bold,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Consumer(builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                onUpdate();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('Update'),
            );
          }),
        )
      ],
    );
  }
}

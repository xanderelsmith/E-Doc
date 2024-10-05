import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/profilepage/presentation/pages/patient/edit_patient_profilepage.dart';
import 'package:healthai/src/features/profilepage/presentation/widgets/patient/biodata_section.dart';
import 'package:healthai/src/features/profilepage/presentation/widgets/patient/patientmedical_recordtab.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../styles/apptextstyles.dart';
import '../../../../../../theme/appcolors.dart';
import '../../../../authentication/data/models/patient.dart';

class PatientProfileBody extends ConsumerStatefulWidget {
  const PatientProfileBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientProfileBodyState();
}

class _PatientProfileBodyState extends ConsumerState<PatientProfileBody>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Patient patient;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    patient = ref.watch(userDetailsProvider) as Patient;
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
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xff196093),
                              AppColors.primaryColorblue,
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
                      imageUrl: patient.profileImageUrl,
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
                  patient.name ?? "",
                  style: Apptextstyles.smalltextStyle14.w500,
                ),
              ),
            ),
            Center(
              child: Text(
                patient.email,
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
                  context.pushNamed(EditPatientProfilePage.id, extra: patient);
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
                  const Text('Medical Records')
                ],
                controller: tabController,
                labelStyle:
                    Apptextstyles.smalltextStyle14.w500.copyWith(fontSize: 15),
                indicatorColor: Colors.transparent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IndexedStack(
                index: tabController.index,
                alignment: Alignment.topLeft,
                children: [
                  PatientBioDataSection(
                    user: patient,
                  ),
                  // ignore: prefer_const_constructors
                  PatientMedicalRecords(
                    patient: patient,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

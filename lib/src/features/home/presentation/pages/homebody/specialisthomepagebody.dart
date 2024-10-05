import 'package:flutter/material.dart';
import 'package:healthai/src/features/home/presentation/pages/homebody/specialist/specialistcurrentappointment.dart';
import 'package:healthai/src/features/home/presentation/pages/specialisthomescreenbody.dart';
import 'package:healthai/src/features/home/presentation/widgets/patienthomepagebody.dart';

import '../../../../authentication/data/models/patient.dart';
import '../../../../authentication/data/models/specialist.dart';

class GetSpecialistHomeScreenBody extends StatelessWidget {
  const GetSpecialistHomeScreenBody(
      {super.key, required this.index, this.user});
  final int index;
  final Specialist? user;
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: index,
      children: [
        const SpecialistHomeBody(),
        SpecialistCurrentAppointment(
          specialist: user,
        ),
        const SizedBox(),
      ],
    );
  }
}

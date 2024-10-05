import 'package:flutter/material.dart';
import 'package:healthai/src/features/profilepage/presentation/widgets/patient/biodata_tile.dart';

import '../../../../authentication/data/models/patient.dart';

class PatientMedicalRecords extends StatelessWidget {
  const PatientMedicalRecords({
    super.key,
    required this.patient,
  });
  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BioDataTile(
            title: 'Blood Group',
            content:
                patient.bloodGroup != null ? patient.bloodGroup!.name : ".."),
        BioDataTile(
            title: 'Genotype',
            content: patient.genotype != null ? patient.genotype!.name : ".."),
        BioDataTile(title: 'Disability', content: patient.disability ?? 'None'),
        BioDataTile(
            title: 'Existing allergies', content: patient.allergies.join(", ")),
      ],
    );
  }
}

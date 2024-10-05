import 'package:flutter/material.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/profilepage/presentation/widgets/patient/biodata_tile.dart';

class PatientBioDataSection extends StatelessWidget {
  const PatientBioDataSection({
    super.key,
    required this.user,
  });
  final Patient user;
  @override
  Widget build(BuildContext context) {
    var nameList = user.name.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BioDataTile(title: 'First name', content: nameList[0]),
        BioDataTile(title: 'Last name', content: nameList[1]),
        BioDataTile(
            title: 'Gender',
            content: user.gender != null ? user.gender!.name : '..'),
        BioDataTile(title: 'Date Of Birth', content: user.dateOfBirth ?? "..."),
        const BioDataTile(title: 'Country', content: 'Nigeria'),
        BioDataTile(title: 'State', content: user.state ?? "...."),
        BioDataTile(title: 'Home Address', content: user.address ?? ""),
      ],
    );
  }
}

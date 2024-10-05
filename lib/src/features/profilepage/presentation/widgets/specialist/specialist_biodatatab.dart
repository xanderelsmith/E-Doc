import 'package:flutter/material.dart';

import '../../../../authentication/data/models/specialist.dart';
import '../patient/biodata_tile.dart';

class SpecialistBiodataTab extends StatelessWidget {
  const SpecialistBiodataTab({
    super.key,
    required this.user,
  });
  final Specialist user;
  @override
  Widget build(BuildContext context) {
    var nameList = user.name.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BioDataTile(title: 'First name', content: nameList[0]),
        BioDataTile(title: 'Last name', content: nameList[1]),
        BioDataTile(title: 'Specialty', content: user.specialty),
        BioDataTile(
            title: 'Gender',
            content: user.gender != null ? user.gender!.name : '..'),
        BioDataTile(title: 'Date Of Birth', content: user.dateOfBirth ?? "..."),
        BioDataTile(title: 'Email', content: user.email),
        const BioDataTile(title: 'Phone Number', content: '....'),
        BioDataTile(
            title: 'Language Spoken',
            content: (user.languages ?? []).join(', ')),
        const BioDataTile(title: 'Country', content: "Nigeria"),
      ],
    );
  }
}

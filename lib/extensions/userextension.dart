import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';

extension UserRefExtension on DocumentSnapshot<Map<String, dynamic>> {
  CustomUserData toCustomUSer() {
    var mapdata = data()!;
    return mapdata['isSpecialist']
        ? Specialist.fromMap(mapdata)
        : Patient.fromMap(mapdata);
  }
}

import 'package:equatable/equatable.dart';

import '../../../profilepage/data/sources/enums/gender.dart';

abstract class CustomUserData extends Equatable {
  final String username;
  final String email;
  final Gender? gender;
  final bool isSpecialist;
  final List allergies;
  final String profileImageUrl;
  const CustomUserData({
    required this.username,
    required this.gender,
    required this.profileImageUrl,
    required this.email,
    required this.isSpecialist,
    required this.allergies,
  });

  Map<String, dynamic> toMap();

  @override
  // TODO: implement props
  List<Object?> get props =>
      [username, email, isSpecialist, allergies, profileImageUrl];
}

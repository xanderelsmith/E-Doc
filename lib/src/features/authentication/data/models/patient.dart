import 'dart:convert';

import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/bloodgroup.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/gender.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/genotype.dart';

class Patient extends CustomUserData {
  final String? medicalHistory;

  final Genotype? genotype;
  final BloodGroup? bloodGroup;
  final String? address;
  final String specialty;
  final String name;
  final String? dateOfBirth;
  final String? disability;
  final String? state;
  final String? phoneNumber;

  const Patient({
    required super.username, // Use superclass username if available
    required super.allergies,
    this.medicalHistory,
    this.address,
    this.disability,
    super.gender,
    this.dateOfBirth,
    this.state,
    this.bloodGroup,
    this.genotype,
    required this.specialty,
    super.isSpecialist = false,
    required this.name,
    required this.phoneNumber,
    required super.profileImageUrl,
    required super.email,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'medicalHistory': medicalHistory,
      'email': email,
      'address': address,
      'disability': disability,
      'dateOfBirth': dateOfBirth,
      'isSpecialist': isSpecialist,
      'name': name,
      'bloodGroup': bloodGroup?.name,
      'genotype': genotype?.name,
      'allergies': allergies,
      'gender': gender?.name,
      'state': state,
      'phone number': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    final medicalHistory = map['medicalHistory'] ?? '';
    final email = map['email']?.toString() ?? '';
    final disability = map['disability']?.toString() ?? '';
    final allergies = map['allergies']?.cast<String>() ?? [];
    final specialty = map['specialty']?.toString() ?? 'Patient';
    final isSpecialist = map['isSpecialist'] as bool? ?? false;
    final name = map['name'] ?? '';
    final phoneNumber = map['phone number']?.toString() ?? '';
    final profileImageUrl = map['profileImageUrl']?.toString() ?? '';
    final Gender? gender = map['gender'] == null
        ? null
        : map['gender'] == 'Male'
            ? Gender.male
            : Gender.female;
    final username = map['name'] ?? '';
    final address = map['address'] ?? '';
    final BloodGroup? bloodGroup = map['bloodGroup'] == null
        ? null
        : BloodGroup.values
            .where(
              (e) => e.name == map['bloodGroup'],
            )
            .first;
    final Genotype? genotype = map['genotype'] == null
        ? null
        : Genotype.values
            .where(
              (e) => e.name == map['genotype'],
            )
            .first;
    final dateOfBirth = map['dateOfBirth'] ?? '';
    final String? state = map['state'] == '' ? null : map['state'];
    return Patient(
      username: username,
      dateOfBirth: dateOfBirth,
      state: state,
      gender: gender,
      bloodGroup: bloodGroup,
      genotype: genotype,
      disability: disability,
      address: address,
      medicalHistory: medicalHistory,
      email: email,
      allergies: allergies,
      specialty: specialty,
      isSpecialist: isSpecialist,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source) as Map<String, dynamic>);
  Patient copyWith({
    String? medicalHistory,
    String? address,
    String? disability,
    String? specialty,
    String? dateOfBirth,
    String? state,
    String? email,
    Gender? gender,
    BloodGroup? bloodGroup,
    Genotype? genotype, // No need for gender ?? gender
    List<String>? allergies,
    bool? isSpecialist,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return Patient(
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      state: state ?? this.state,
      specialty: specialty ?? this.specialty,
      disability: disability ?? this.disability,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      email: email ?? this.email, bloodGroup: bloodGroup ?? this.bloodGroup,
      genotype: genotype ?? this.genotype,
      username: username,
      gender: gender ?? super.gender, // Use this.gender directly
      allergies: allergies ?? this.allergies,
      isSpecialist: isSpecialist ?? this.isSpecialist,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/gender.dart';

class Specialist extends CustomUserData {
  final String? medicalHistory;
  final List<Timestamp>? availableTime;
  final String? genotype;
  final String? bloodGroup;
  final String? address;
  final String specialty;
  final String name;
  final String? state;
  final String? phoneNumber;
  final List<String>? languages;
  final String? dateOfBirth;

  const Specialist({
    this.dateOfBirth,
    this.availableTime,
    this.state,
    this.languages,
    required super.allergies,
    this.medicalHistory,
    this.address,
    super.gender,
    this.bloodGroup,
    this.genotype,
    required this.specialty,
    required this.name,
    required this.phoneNumber,
    required super.profileImageUrl,
    required super.email,
  }) : super(
          username: name,
          isSpecialist: true,
        );

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'specialty': specialty,
      'isSpecialist': true, 'dateOfBirth': dateOfBirth,
      'username': username,
      'availableTime': availableTime,
      'state': state,
      'languages': languages ?? [],

      'name': name,
      'email': email,
      'allergies': allergies, 'gender': gender?.name,
      'address': address,
      'phone number': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'medicalHistory': medicalHistory, // Added missing parameter
    };
  }

  factory Specialist.fromMap(Map map) {
    final List<String> languages = List.from(map['languages'] ?? []);
    final List<Timestamp> availableTime = List.from(map['availableTime'] ?? []);
    final String? state = map['state'] == '' ? null : map['state'];
    final dateOfBirth = map['dateOfBirth'] ?? '';
    // Handle missing or incorrect data types gracefully
    final specialty = map['specialty'] ?? '';
    final name = map['name'] ?? '';
    final email = map['email'] ?? '';
    final phoneNumber = map['phone number'].toString();
    final profileImageUrl = map['profileImageUrl'] ?? '';

    final bloodGroup = map['bloodGroup'] ?? '';
    final genotype = map['genotype'] ?? '';
    final Gender? gender = map['gender'] == null
        ? null
        : map['gender'] == 'Male'
            ? Gender.male
            : Gender.female;
    final address = map['address'] ?? '';
    return Specialist(
      email: email,
      dateOfBirth: dateOfBirth, availableTime: availableTime,
      specialty: specialty,
      name: name,
      languages: languages,
      address: address,
      state: state,
      bloodGroup: bloodGroup,
      gender: gender,
      genotype: genotype,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,

      allergies: [],
      medicalHistory: map['medicalHistory'] ?? '', // Added missing parameter
    );
  }

  String toJson() => json.encode(toMap());

  factory Specialist.fromJson(String source) =>
      Specialist.fromMap(json.decode(source) as Map<String, dynamic>);

  Specialist copyWith({
    String? medicalHistory,
    String? address,
    String? specialty,
    List<String>? languages,
    String? dateOfBirth,
    List<Timestamp>? availableTime,
    String? email,
    String? state,
    Gender? gender,
    String? bloodGroup,
    String? genotype,
    List<String>? allergies,
    bool? isSpecialist,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return Specialist(
      availableTime: availableTime ?? this.availableTime,
      languages: languages ?? this.languages,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      specialty: specialty ?? this.specialty,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      allergies: allergies ?? this.allergies,
      address: address ?? this.address,
      state: state ?? this.state,
      gender: gender ?? super.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      genotype: genotype ?? this.genotype,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      email: email ?? this.email,
    );
  }
}

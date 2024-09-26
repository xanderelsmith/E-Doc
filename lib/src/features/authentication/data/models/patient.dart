// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:healthai/src/features/authentication/data/models/user.dart';

class Patient extends CustomUserData {
  String? medicalHistory;
  String email;

  String specialty;
  String name;
  String? phoneNumber;
  String? profileImageUrl;

  Patient({
    required super.username, // Use superclass username if available
    required super.allergies,
    this.medicalHistory,
    required this.email,
    required this.specialty,
    required super.isSpecialist,
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'medicalHistory': medicalHistory,
      'email': email,
      'isSpecialist': isSpecialist,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    // Handle missing or incorrect data types gracefully
    final medicalHistory = map['medicalHistory'] ?? '';
    final email = map['email']?.toString() ?? '';
    final allergies = map['allergies']?.cast<String>() ?? [];
    final specialty = map['specialty']?.toString() ?? 'Patient';
    final isSpecialist = map['isSpecialist'] as bool? ?? false;
    final name = map['name'] ?? '';
    final phoneNumber = map['phone number']?.toString() ?? '';
    final profileImageUrl = map['profileImageUrl']?.toString() ?? '';

    final username = map['username'] ?? '';

    return Patient(
      username: username,
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
    String? email,
    String? specialty,
  }) {
    return Patient(
      specialty: specialty ?? this.specialty,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      email: email ?? this.email,
      username: username,
      allergies: allergies,
      isSpecialist: isSpecialist,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    );
  }
}

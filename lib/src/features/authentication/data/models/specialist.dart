// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:healthai/src/features/authentication/data/models/user.dart';

class Specialist extends CustomUserData {
  String specialty;
  String name;
  String phoneNumber;
  String profileImageUrl;

  Specialist({
    required super.username,
    required super.allergies,
    required this.specialty,
    required this.name,
    required this.phoneNumber,
    required this.profileImageUrl,
  }) : super(
          isSpecialist: true,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'specialty': specialty,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Specialist.fromMap(Map<String, dynamic> map) {
    // Handle missing or incorrect data types gracefully
    final specialty = map['specialty']?.toString() ?? '';
    final name = map['name']?.toString() ?? '';
    final phoneNumber = map['phone number']?.toString() ?? '';
    final profileImageUrl = map['profileImageUrl']?.toString() ?? '';

    return Specialist(
      specialty: specialty,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      username: '', // Use superclass username if available
      allergies: [], // Use superclass allergies if available
    );
  }

  String toJson() => json.encode(toMap());

  factory Specialist.fromJson(String source) =>
      Specialist.fromMap(json.decode(source) as Map<String, dynamic>);

  Specialist copyWith({
    String? specialty,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) {
    return Specialist(
      specialty: specialty ?? this.specialty,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      username: username,
      allergies: allergies,
    );
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String id;
  final bool isCalling;
  final bool hasPaid;
  final Timestamp createdAt;
  final List<Timestamp> dates;
  final String nameOfAppointment;
  final DocumentReference patient;
  final DocumentReference specialist;
  final String temperature;
  final String token;
  final List<String> symptoms; // Added symptoms list
  final List<String> allergies; // Added allergies list
  final String complaint; // Added complaint string

  const Appointment({
    required this.id,
    required this.createdAt,
    required this.hasPaid,
    required this.isCalling,
    required this.dates,
    required this.nameOfAppointment,
    required this.patient,
    required this.specialist,
    this.temperature = '',
    this.token = '',
    this.symptoms = const [], // Initialize as empty list
    this.allergies = const [], // Initialize as empty list
    required this.complaint,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      hasPaid: json['hasPaid'], createdAt: json['createdAt'],
      isCalling: json['isCalling'],
      id: json['id'],
      dates: List<Timestamp>.from(json['dates']),
      nameOfAppointment: json['name'] as String,
      patient: json['patient'],
      specialist: json['specialist'],
      temperature: json['temperature'] ?? '',
      token: json['token'] ?? '',
      symptoms: List<String>.from(
          json['symptoms'] ?? []), // Handle potential missing or empty list
      allergies: List<String>.from(
          json['allergies'] ?? []), // Handle potential missing or empty list
      complaint: json['complaint'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hasPaid': hasPaid,
      'createdAt': createdAt,
      'dates': dates,
      'isCalling': isCalling,
      'name': nameOfAppointment,
      'patient': patient,
      'specialist': specialist,
      'temperature': temperature,
      'token': token,
      'symptoms': symptoms,
      'allergies': allergies,
      'complaint': complaint,
    };
  }

  factory Appointment.fromQuerySnapshot(DocumentSnapshot snapshot) {
    Map map = snapshot.data() as Map;
    return Appointment(
      createdAt: map['createdAt'],
      isCalling: map['isCalling'],
      id: snapshot.id,
      hasPaid: map['hasPaid'],
      dates: List<Timestamp>.from(map['dates']),
      nameOfAppointment: map['name'] as String,
      patient: map['patient'],
      specialist: map['specialist'],
      temperature: map['temperature'] ?? '',
      token: map['token'] ?? '',
      symptoms: List<String>.from(map['symptoms'] ?? []),
      allergies: List<String>.from(map['allergies'] ?? []),
      complaint: map['complaint'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  Appointment copyWith({
    String? id,
    bool? isCalling,
    Timestamp? createdAt,
    bool? hasPaid,
    List<Timestamp>? dates,
    String? nameOfAppointment,
    DocumentReference? patient,
    DocumentReference? specialist,
    String? temperature,
    String? token,
    List<String>? symptoms,
    List<String>? allergies,
    String? complaint,
  }) {
    return Appointment(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      isCalling: isCalling ?? this.isCalling,
      hasPaid: hasPaid ?? this.hasPaid,
      dates: dates ?? this.dates,
      nameOfAppointment: nameOfAppointment ?? this.nameOfAppointment,
      patient: patient ?? this.patient,
      specialist: specialist ?? this.specialist,
      temperature: temperature ?? this.temperature,
      token: token ?? this.token,
      symptoms: symptoms ?? this.symptoms,
      allergies: allergies ?? this.allergies,
      complaint: complaint ?? this.complaint,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        isCalling,
        hasPaid,
        dates,
        createdAt,
        nameOfAppointment,
        patient,
        specialist,
        temperature,
        token,
        symptoms,
        allergies,
        complaint,
      ];
}

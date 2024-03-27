import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String lastName;
  final String motherLastName;
  final List<String> specialties;
  final String schedule; // Campo para almacenar el horario como una cadena
  final String description;
  final String education;

  Doctor({
    required this.name,
    required this.lastName,
    required this.motherLastName,
    required this.specialties,
    required this.schedule, // Utiliza el campo 'schedule' para el horario
    required this.description,
    required this.education,
  });

  factory Doctor.fromString(String doctorString) {
    List<String> values = doctorString.split('|');
    return Doctor(
      name: values[0],
      lastName: values[1],
      motherLastName: values[2],
      specialties: values[3].split(','),
      schedule: values[4],
      description: values[5],
      education: values[6],
    );
  }

  @override
  String toString() {
    String specialtiesString = specialties.join(',');
    return '$name|$lastName|$motherLastName|$specialtiesString|$schedule|$description|$education';
  }
}

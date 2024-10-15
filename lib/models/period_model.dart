import 'package:cloud_firestore/cloud_firestore.dart';

class PeriodData {
  final DateTime lastPeriodStart;     // เก็บเป็น DateTime ใน Dart, Timestamp ใน Firestore
  final int cycleLength;             // integer
  final int periodLength;            // integer
  final List<String>? symptoms;      // List<String> หรือ null
  final String? notes;               // String หรือ null
  final DateTime? createdAt;         // เก็บเป็น DateTime ใน Dart, Timestamp ใน Firestore
  final DateTime? updatedAt;         // เก็บเป็น DateTime ใน Dart, Timestamp ใน Firestore

  PeriodData({
    required this.lastPeriodStart,
    required this.cycleLength,
    required this.periodLength,
    this.symptoms,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  // แปลงจาก Firestore Document เป็น PeriodData object
  factory PeriodData.fromFirestore(Map<String, dynamic> data) {
    return PeriodData(
      lastPeriodStart: (data['last_period_start'] as Timestamp).toDate(),
      cycleLength: data['cycle_length'] as int,
      periodLength: data['period_length'] as int,
      symptoms: data['symptoms'] != null
          ? List<String>.from(data['symptoms'])
          : null,
      notes: data['notes'] as String?,
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
      updatedAt: data['updated_at'] != null
          ? (data['updated_at'] as Timestamp).toDate()
          : null,
    );
  }

  // แปลงจาก PeriodData object เป็น Map สำหรับเก็บใน Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'last_period_start': Timestamp.fromDate(lastPeriodStart),
      'cycle_length': cycleLength,
      'period_length': periodLength,
      'symptoms': symptoms,
      'notes': notes,
      'created_at': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}
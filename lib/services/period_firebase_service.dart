import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeriodData {
  final DateTime lastPeriodStart;
  final int cycleLength;
  final int periodLength;
  final List<String>? symptoms;
  final String? notes;

  PeriodData({
    required this.lastPeriodStart,
    required this.cycleLength,
    required this.periodLength,
    this.symptoms,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'last_period_start': lastPeriodStart.toIso8601String(),
      'cycle_length': cycleLength,
      'period_length': periodLength,
      'symptoms': symptoms,
      'notes': notes,
    };
  }

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      lastPeriodStart: DateTime.parse(json['last_period_start']),
      cycleLength: json['cycle_length'] ?? 28,
      periodLength: json['period_length'] ?? 5,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      notes: json['notes'],
    );
  }
}

class PeriodFirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection references
  static DocumentReference _getUserDoc() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    return _firestore.collection('users').doc(userId);
  }

  static DocumentReference _getCurrentCycleDoc() {
    return _getUserDoc().collection('period_data').doc('current_cycle');
  }

  static CollectionReference _getHistoryCollection() {
    return _getCurrentCycleDoc().collection('history');
  }

  // เพิ่มหรืออัพเดทข้อมูลรอบเดือน
  static Future<void> updatePeriodData(PeriodData periodData) async {
    try {
      await _getCurrentCycleDoc().set(
        periodData.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Failed to update period data: $e');
      rethrow;
    }
  }

  // ดึงข้อมูลรอบเดือนล่าสุด
  static Future<PeriodData?> getCurrentPeriodData() async {
    try {
      DocumentSnapshot doc = await _getCurrentCycleDoc().get();

      if (!doc.exists) return null;

      return PeriodData.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Failed to get current period data: $e');
      rethrow;
    }
  }

  // ดึงประวัติข้อมูลรอบเดือน
  static Future<List<PeriodData>> getPeriodHistory({int limit = 12}) async {
    try {
      QuerySnapshot querySnapshot = await _getHistoryCollection()
          .orderBy('last_period_start', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => PeriodData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Failed to get period history: $e');
      rethrow;
    }
  }

  // คำนวณวันที่คาดว่าจะมีประจำเดือนครั้งต่อไป
  static DateTime calculateNextPeriod(PeriodData currentData) {
    return currentData.lastPeriodStart.add(Duration(days: currentData.cycleLength));
  }

  // คำนวณช่วงที่มีโอกาสตั้งครรภ์สูง (fertile window)
  static List<DateTime> calculateFertileWindow(PeriodData currentData) {
    final ovulationDay = currentData.lastPeriodStart.add(
      Duration(days: currentData.cycleLength - 14),
    );

    return List.generate(
      6,
          (index) => ovulationDay.subtract(Duration(days: 3 - index)),
    );
  }

  // บันทึกข้อมูลรอบเดือนใหม่และเก็บข้อมูลเก่าไว้ในประวัติ
  static Future<void> logNewPeriod(
      DateTime startDate, {
        List<String>? symptoms,
        String? notes,
      }) async {
    try {
      PeriodData? currentData = await getCurrentPeriodData();

      if (currentData != null) {
        // เก็บข้อมูลปัจจุบันไว้ในประวัติ
        await _getHistoryCollection().add(currentData.toJson());
      }

      // สร้างข้อมูลรอบเดือนใหม่
      PeriodData newPeriodData = PeriodData(
        lastPeriodStart: startDate,
        cycleLength: currentData?.cycleLength ?? 28,
        periodLength: currentData?.periodLength ?? 5,
        symptoms: symptoms,
        notes: notes,
      );

      // อัพเดทข้อมูลรอบเดือนใหม่
      await updatePeriodData(newPeriodData);
    } catch (e) {
      print('Failed to log new period: $e');
      rethrow;
    }
  }

  // Stream สำหรับติดตามการเปลี่ยนแปลงข้อมูลรอบเดือนปัจจุบัน
  static Stream<PeriodData?> streamCurrentPeriodData() {
    return _getCurrentCycleDoc().snapshots().map((doc) {
      if (!doc.exists) return null;
      return PeriodData.fromJson(doc.data() as Map<String, dynamic>);
    });
  }
}
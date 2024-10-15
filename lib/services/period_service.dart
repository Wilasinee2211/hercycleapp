import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/period_model.dart';

class PeriodServiceException implements Exception {
  final String message;
  final String? code;

  PeriodServiceException(this.message, {this.code});

  @override
  String toString() => 'PeriodServiceException: $message ${code != null ? '(Code: $code)' : ''}';
}

class PeriodService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PeriodService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  void _validateUser() {
    if (userId.isEmpty) {
      throw PeriodServiceException('ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบใหม่', code: 'user-not-found');
    }
  }

  DocumentReference<Map<String, dynamic>> _getUserDoc() {
    return _firestore.collection('users').doc(userId);
  }

  Future<void> updatePeriodData(PeriodData periodData) async {
    try {
      _validateUser();

      await _getUserDoc().set({
        'period_data': periodData.toFirestore(),
      }, SetOptions(merge: true));

    } on FirebaseException catch (e) {
      throw PeriodServiceException(
        'ไม่สามารถบันทึกข้อมูลได้: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw PeriodServiceException('ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  Future<PeriodData?> getPeriodData() async {
    try {
      _validateUser();

      final doc = await _getUserDoc().get();
      final data = doc.data();

      if (data != null && data['period_data'] != null) {
        return PeriodData.fromFirestore(data['period_data'] as Map<String, dynamic>);
      }

      return null;
    } on FirebaseException catch (e) {
      throw PeriodServiceException(
        'ไม่สามารถดึงข้อมูลได้: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw PeriodServiceException('ไม่สามารถดึงข้อมูลได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  Stream<PeriodData?> streamPeriodData() {
    try {
      _validateUser();

      return _getUserDoc().snapshots().map((doc) {
        final data = doc.data();
        if (data != null && data['period_data'] != null) {
          return PeriodData.fromFirestore(data['period_data'] as Map<String, dynamic>);
        }
        return null;
      });
    } catch (e) {
      return Stream.error(
          PeriodServiceException('ไม่สามารถติดตามข้อมูลได้ กรุณาลองใหม่อีกครั้ง')
      );
    }
  }

  // สำหรับการคำนวณวันที่ที่เกี่ยวข้อง
  DateTime calculateNextPeriod(PeriodData data) {
    return data.lastPeriodStart.add(Duration(days: data.cycleLength));
  }

  DateTime calculatePeriodEndDate(PeriodData data) {
    return data.lastPeriodStart.add(Duration(days: data.periodLength));
  }

  bool isCurrentlyOnPeriod(PeriodData data) {
    final now = DateTime.now();
    final periodEnd = calculatePeriodEndDate(data);
    return now.isAfter(data.lastPeriodStart) && now.isBefore(periodEnd);
  }
}
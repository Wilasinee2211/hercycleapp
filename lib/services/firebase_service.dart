import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      if (e is FirebaseException) {
        print('Firebase error: ${e.message}');
      } else {
        print('Unexpected error: $e');
      }
    }
  }

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // เพิ่มผู้ใช้ใหม่ใน Firestore
  static Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print('Failed to add user: $e');
      rethrow;
    }
  }

  // ดึงข้อมูลผู้ใช้จาก Firestore
  static Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await firestore.collection('users').doc(userId).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Failed to get user data: $e');
      rethrow;
    }
  }

  // อัปเดตข้อมูลผู้ใช้ใน Firestore
  static Future<void> updateUserData(String userId, Map<String, dynamic> newData) async {
    try {
      await firestore.collection('users').doc(userId).update(newData);
    } catch (e) {
      print('Failed to update user data: $e');
      rethrow;
    }
  }

  // ลบผู้ใช้จาก Firestore
  static Future<void> deleteUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Failed to delete user: $e');
      rethrow;
    }
  }

  // ตรวจสอบสถานะการเข้าสู่ระบบของผู้ใช้
  static bool isUserLoggedIn() {
    return auth.currentUser != null;
  }

  // ลงชื่อออกจากระบบ
  static Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print('Failed to sign out: $e');
      rethrow;
    }
  }
}
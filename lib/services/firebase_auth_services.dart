import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  late final FirebaseAuth _auth;

  FirebaseAuthServices() {
    _auth = FirebaseAuth.instance;
  }

  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'email-already-in-use':
        return Exception('The account already exists for that email.');
      case 'user-not-found':
        return Exception('No user found for that email.');
      case 'wrong-password':
        return Exception('Wrong password provided for that user.');
      default:
        return Exception(e.message ?? 'An unknown error occurred.');
    }
  }

  // เพิ่มเมธอดสำหรับออกจากระบบ
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // เพิ่มเมธอดสำหรับตรวจสอบสถานะการเข้าสู่ระบบ
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
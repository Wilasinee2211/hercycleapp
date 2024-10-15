import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _register(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, 'กรุณากรอกข้อมูลให้ครบถ้วน', isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage(context, 'กรุณากรอกอีเมลให้ถูกต้อง', isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      _showMessage(context, 'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน', isError: true);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );


      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      _showMessage(context, 'ลงทะเบียนสำเร็จ');

      Profile userProfile = Profile(name: name, email: email, password: password);

      await Future.delayed(Duration(seconds: 2));

      Navigator.pushReplacementNamed(
        context,
        '/login',
        arguments: userProfile,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'รหัสผ่านที่ให้มาอ่อนแอเกินไป';
          break;
        case 'email-already-in-use':
          errorMessage = 'บัญชีนี้มีอยู่แล้วสำหรับอีเมลนี้';
          break;
        default:
          errorMessage = 'เกิดข้อผิดพลาดในการลงทะเบียน: ${e.message}';
      }
      _showMessage(context, errorMessage, isError: true);
    } catch (e) {
      _showMessage(context, 'เกิดข้อผิดพลาดที่ไม่คาดคิด: $e', isError: true);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียน'),
        backgroundColor: Color(0xFF0C0D31),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/img01.png',
                  height: 150,
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อ',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันรหัสผ่าน',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('ลงทะเบียน', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0C0D31),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: _isLoading ? null : () => _register(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
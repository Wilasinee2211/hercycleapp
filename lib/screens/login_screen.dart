import 'package:flutter/material.dart';
import '../profile.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Profile? userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // รับข้อมูลจากหน้าจอ RegisterScreen
    final Profile? args = ModalRoute.of(context)!.settings.arguments as Profile?;
    if (args != null) {
      userProfile = args;
    }
  }

  void _showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _login(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError(context, 'กรุณากรอก E-mail และรหัสผ่าน');
    } else if (userProfile != null &&
        email == userProfile!.email &&
        password == userProfile!.password) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showError(context, 'E-mail หรือรหัสผ่านไม่ถูกต้อง');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ลงชื่อเข้าใช้\nHerCycle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C0D31),
              ),
            ),
            SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            CheckboxListTile(
              title: Text('จดจำการเข้าสู่ระบบ', style: TextStyle(color: Color(0xFF0C0D31))),
              controlAffinity: ListTileControlAffinity.leading,
              value: false,
              onChanged: (bool? value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0C0D31),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                _login(context);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('ลงทะเบียน', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF470606),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('ลืมรหัสผ่าน', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFF3E0),
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                // Navigate to forgot password page
              },
            ),
          ],
        ),
      ),
    );
  }
}
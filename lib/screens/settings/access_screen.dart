import 'package:flutter/material.dart';
import 'set_password_screen.dart';

class AccessScreen extends StatefulWidget {
  @override
  _AccessScreenState createState() => _AccessScreenState();
}

class _AccessScreenState extends State<AccessScreen> {
  bool isPasswordLockEnabled = false;
  bool isExternalAccessEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รหัสลับและการเข้าถึง',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0C0D31),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/password.png',
                height: 100,
              ),
            ),
            SizedBox(height: 50),
            SwitchListTile(
              title: Text('ล็อครหัสผ่าน'),
              value: isPasswordLockEnabled,
              activeColor: Color(0xFF470606),
              onChanged: (bool value) {
                setState(() {
                  isPasswordLockEnabled = value;
                });

                if (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetPasswordScreen(),
                    ),
                  );
                }
              },
            ),
            SwitchListTile(
              title: Text('เข้าถึงข้อมูลจากแอปภายนอก'),
              value: isExternalAccessEnabled,
              activeColor: Color(0xFF470606),
              onChanged: (bool value) {
                setState(() {
                  isExternalAccessEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
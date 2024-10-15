import 'package:flutter/material.dart';

class SetPasswordScreen extends StatefulWidget {
  @override
  _SetPasswordScreenState createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  String _enteredPassword = '';

  void _addDigit(String digit) {
    if (_enteredPassword.length < 4) {
      setState(() {
        _enteredPassword += digit;
      });
    }
  }

  void _deleteLastDigit() {
    if (_enteredPassword.isNotEmpty) {
      setState(() {
        _enteredPassword = _enteredPassword.substring(0, _enteredPassword.length - 1);
      });
    }
  }

  void _confirmPassword() {
    if (_enteredPassword.length == 4) {
      // บันทึกรหัสผ่านและกลับไปหน้าก่อนหน้า
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ตั้งรหัสผ่านสำเร็จ')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกรหัสผ่าน 4 หลัก')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C0D31),
        title: Text('ล็อครหัสผ่าน', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'โปรดใส่รหัสผ่าน',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _enteredPassword.length
                        ? Colors.black
                        : Colors.grey,
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                ),
                itemCount: 12, // 0-9 ตัวเลข + ลบ
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return Container(); // ช่องว่าง
                  } else if (index == 11) {
                    return IconButton(
                      onPressed: _deleteLastDigit,
                      icon: Icon(Icons.backspace),
                      color: Colors.black,
                      iconSize: 40,
                    );
                  } else {
                    String digit = index == 10 ? '0' : '${index + 1}';
                    return GestureDetector(
                      onTap: () {
                        _addDigit(digit);
                      },
                      child: Center(
                        child: Text(
                          digit,
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: _confirmPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF470606),
              ),
              child: Text(
                'ยืนยัน',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

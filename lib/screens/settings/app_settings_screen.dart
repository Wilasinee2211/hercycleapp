import 'package:flutter/material.dart';

class AppSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่า',
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'ภาษา',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('เปลี่ยนภาษา'),
                DropdownButton<String>(
                  value: 'TH',
                  items: <String>['TH', 'EN'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Implement change language logic here
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'การเชื่อมต่อ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('แอปเพื่อสุขภาพ'),
                Switch(
                  value: true, // สถานะปุ่มเปิดปิด
                  onChanged: (bool newValue) {
                    // Implement toggle logic here
                  },
                  activeColor: Color(0xFF470606),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
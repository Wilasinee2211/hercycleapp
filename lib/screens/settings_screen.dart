import 'package:flutter/material.dart';
import 'settings/report_screen.dart';
import 'settings/cycle_ovulation_screen.dart';
import 'settings/app_settings_screen.dart';
import 'settings/helping_screen.dart';
import 'settings/access_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่า',
          style: TextStyle(color: Color(0xFFF6E3C5)),
        ),
        backgroundColor: Color(0xFF470606),
        iconTheme: IconThemeData(color: Color(0xFFF6E3C5)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Center(
              child: DropdownButton<String>(
                value: 'TH',
                icon: Icon(Icons.language, color: Colors.white),
                dropdownColor: Color(0xFF470606),
                style: TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  // Implement language change functionality
                },
                items: <String>['TH', 'EN']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'ตั้งค่า',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C0D31),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color(0xFF0C0D31),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/img05.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'เกศวัฒน์ เจ๊ะวันห้าวซุม',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF470606),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            'แก้ไขข้อมูล',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            // Implement edit profile
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: <Widget>[
                  buildSettingsButton(context, 'กราฟและรายงาน', Icons.bar_chart),
                  buildSettingsButton(context, 'วัฎจักรและการตกไข่', Icons.calendar_today),
                  buildSettingsButton(context, 'ตั้งค่า', Icons.settings),
                  buildSettingsButton(context, 'รหัสลับและการเข้าถึง', Icons.lock), // Navigate to AccessScreen
                  buildSettingsButton(context, 'การแจ้งเตือน', Icons.notifications),
                  buildSettingsButton(context, 'ช่วยเหลือ', Icons.help),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('ออกจากระบบ', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF470606),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsButton(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0C0D31),
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFF0C0D31)),
          ),
        ),
        onPressed: () {
          if (title == 'กราฟและรายงาน') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportScreen()),
            );
          } else if (title == 'วัฎจักรและการตกไข่') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CycleOvulationScreen()),
            );
          } else if (title == 'ตั้งค่า') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppSettingsScreen()),
            );
          } else if (title == 'การแจ้งเตือน') {
            Navigator.pushNamed(context, '/notification_screen');
          } else if (title == 'ช่วยเหลือ') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpingScreen()),
            );
          } else if (title == 'รหัสลับและการเข้าถึง') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AccessScreen()),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18)),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}

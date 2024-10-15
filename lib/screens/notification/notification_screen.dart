import 'package:flutter/material.dart';
import 'notidetail.dart';
import 'mednoti.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> medicationReminders = [];

  bool isOnPeriod = false;
  bool isPeriodEnded = false;
  bool isOvulating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF470606),
        title: Text(
          'การแจ้งเตือน',
          style: TextStyle(color: Color(0xFFF6E3C5)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFF6E3C5)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รอบประจำเดือน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('ประจำเดือนกำลังมา'),
              value: isOnPeriod,
              onChanged: (value) {
                setState(() {
                  isOnPeriod = value;
                });
              },
              activeColor: Color(0xFF0C0D31),
            ),
            SwitchListTile(
              title: Text('ประจำเดือนหมด'),
              value: isPeriodEnded,
              onChanged: (value) {
                setState(() {
                  isPeriodEnded = value;
                });
              },
              activeColor: Color(0xFF0C0D31),
            ),
            SwitchListTile(
              title: Text('การตกไข่'),
              value: isOvulating,
              onChanged: (value) {
                setState(() {
                  isOvulating = value;
                });
              },
              activeColor: Color(0xFF0C0D31),
            ),
            SizedBox(height: 20),
            Text(
              'การทานยา',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(
                'เพิ่มการแจ้งเตือนการทานยา',
                style: TextStyle(color: Color(0xFFF6E3C5)),
              ),
              onPressed: _addMedicationReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF470606),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 10),
            // แสดงรายการการแจ้งเตือนการทานยา
            ...medicationReminders.map((reminder) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: Text(reminder['medicineName'] ?? ''),
                  subtitle: Text(reminder['message'] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(reminder['time'] ?? ''),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () => _editMedicationReminder(reminder, medicationReminders.indexOf(reminder)),
                      ),
                    ],
                  ),
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _addMedicationReminder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotiDetail()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        medicationReminders.add(result['data']);
      });
    }
  }

  void _editMedicationReminder(Map<String, dynamic> reminder, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedNoti(
          medication: reminder,
          documentId: reminder['id'],
        ),
      ),
    );

    if (result == 'deleted') {
      setState(() {
        medicationReminders.removeAt(index);
      });
    } else if (result != null) {
      setState(() {
        medicationReminders[index] = result;
      });
    }
  }
}

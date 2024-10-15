import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedNoti extends StatefulWidget {
  final Map<String, dynamic> medication;
  final String documentId;

  MedNoti({required this.medication, required this.documentId});

  @override
  _MedNotiState createState() => _MedNotiState();
}

class _MedNotiState extends State<MedNoti> {
  late TextEditingController _medicineNameController;
  late TextEditingController _messageController;
  late TextEditingController _pillsPerDayController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _medicineNameController = TextEditingController(
        text: widget.medication['medicineName']?.toString() ?? '');
    _messageController =
        TextEditingController(text: widget.medication['message']?.toString() ?? '');
    _pillsPerDayController = TextEditingController(
        text: widget.medication['pillsPerDay']?.toString() ?? '1');
    _selectedTime = _parseTimeString(widget.medication['time'] ?? '');
  }

  TimeOfDay _parseTimeString(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return TimeOfDay.now();
    }

    try {
      final parts = timeString.split(':');
      if (parts.length == 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        // Ensure hour is within 0-23 range
        hour = hour % 24;

        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      print('Error parsing time string: $e');
    }

    return TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แก้ไขการแจ้งเตือนทานยา',
          style: TextStyle(color: Color(0xFFF6E3C5)),
        ),
        backgroundColor: Color(0xFF470606),
        iconTheme: IconThemeData(color: Color(0xFFF6E3C5)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _onDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/img01.png', height: 100),
            ),
            SizedBox(height: 20),
            Text('รายละเอียด', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _medicineNameController,
              decoration: InputDecoration(
                hintText: 'ชื่อยา',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _pillsPerDayController,
              decoration: InputDecoration(
                hintText: 'จำนวนยา/วัน',
                border: OutlineInputBorder(),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        int currentValue = int.parse(_pillsPerDayController.text);
                        setState(() {
                          _pillsPerDayController.text = (currentValue + 1).toString();
                        });
                      },
                      child: Icon(Icons.arrow_drop_up),
                    ),
                    InkWell(
                      onTap: () {
                        int currentValue = int.parse(_pillsPerDayController.text);
                        if (currentValue > 1) {
                          setState(() {
                            _pillsPerDayController.text = (currentValue - 1).toString();
                          });
                        }
                      },
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('ระยะเวลาแจ้งเตือน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: _selectTime,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Text('แจ้งเตือน'),
                    Spacer(),
                    Text('${_selectedTime.format(context)}', style: TextStyle(color: Color(0xFF470606))),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'ข้อความ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                child: Text('บันทึก', style: TextStyle(color: Color(0xFFF6E3C5))),
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0C0D31),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _onSave() async {
    if (_medicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกชื่อยา')),
      );
      return;
    }

    final updatedData = {
      'medicineName': _medicineNameController.text.isNotEmpty ? _medicineNameController.text : '',
      'pillsPerDay': int.tryParse(_pillsPerDayController.text) ?? 1, // ตั้งค่าเริ่มต้นเป็น 1 หากแปลงไม่ได้
      'time': _selectedTime.format(context),
      'message': _messageController.text.isNotEmpty ? _messageController.text : '',
    };

    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .doc(widget.documentId)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('อัปเดตข้อมูลสำเร็จ')),
      );
      Navigator.pop(context, updatedData);
    } catch (e) {
      print('Error updating medication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล: $e')),
      );
    }
  }

  void _onDelete() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .doc(widget.documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบข้อมูลสำเร็จ')),
      );
      Navigator.pop(context, 'deleted');
    } catch (e) {
      print('Error deleting medication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการลบข้อมูล: $e')),
      );
    }
  }

  @override
  void dispose() {
    _medicineNameController.dispose();
    _messageController.dispose();
    _pillsPerDayController.dispose();
    super.dispose();
  }
}

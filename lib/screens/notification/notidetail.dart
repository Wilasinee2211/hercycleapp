import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotiDetail extends StatefulWidget {
  @override
  _NotiDetailState createState() => _NotiDetailState();
}

class _NotiDetailState extends State<NotiDetail> {
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _pillsPerDayController = TextEditingController(text: '1');
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);

  // เปลี่ยนให้ค่าเริ่มต้นเป็น null และเพิ่มตัวเลือก 'ประเภทยา'
  String? _selectedMedicineType;
  final List<String> _medicineTypes = ['ยาคุม', 'ยาสตรี', 'ยาแก้ปวดประจำเดือน'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แจ้งเตือนทานยา',
          style: TextStyle(color: Color(0xFFF6E3C5)),
        ),
        backgroundColor: Color(0xFF470606),
        iconTheme: IconThemeData(color: Color(0xFFF6E3C5)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/img06.png', height: 100),
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
            // Dropdown ที่แสดง 'ประเภทยา' เป็น default
            DropdownButtonFormField<String>(
              value: _selectedMedicineType,
              hint: Text('ประเภทยา'), // เพิ่ม hint 'ประเภทยา'
              items: _medicineTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMedicineType = newValue;
                });
              },
              decoration: InputDecoration(
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
                child: Text('เสร็จสิ้น', style: TextStyle(color: Color(0xFFF6E3C5))),
                onPressed: _onFinish,
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

  void _onFinish() async {
    if (_medicineNameController.text.isEmpty || _selectedMedicineType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
      );
      return;
    }

    final medicationData = {
      'medicineName': _medicineNameController.text,
      'medicineType': _selectedMedicineType,
      'pillsPerDay': int.parse(_pillsPerDayController.text),
      'time': '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
      'message': _messageController.text,
    };

    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('medications')
          .add(medicationData);

      medicationData['id'] = docRef.id;
      Navigator.pop(context, {'data': medicationData});
    } catch (e) {
      print('Error saving medication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e')),
      );
    }
  }
}

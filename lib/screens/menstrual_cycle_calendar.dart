import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MenstrualCycleCalendar extends StatefulWidget {
  @override
  _MenstrualCycleCalendarState createState() => _MenstrualCycleCalendarState();
}

class _MenstrualCycleCalendarState extends State<MenstrualCycleCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Set<DateTime> _selectedDays = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปฏิทิน'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return _selectedDays.contains(day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_selectedDays.contains(selectedDay)) {
                  _selectedDays.remove(selectedDay);
                } else {
                  _selectedDays.add(selectedDay);
                }
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white), // กำหนดให้ข้อความเป็นสีขาว
                ),
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF470606),
                ),
              ),
              ElevatedButton(
                child: Text(
                  'บันทึก',
                  style: TextStyle(color: Colors.white), // กำหนดให้ข้อความเป็นสีขาว
                ),
                onPressed: () {
                  // บันทึกข้อมูลที่เลือก
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C0D31),
                ),
              ),

            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
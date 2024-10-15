import 'package:flutter/material.dart';

class CycleOvulationScreen extends StatefulWidget {
  @override
  _CycleOvulationScreenState createState() => _CycleOvulationScreenState();
}

class _CycleOvulationScreenState extends State<CycleOvulationScreen> {
  int cycleLength = 21;
  int menstrualLength = 1;
  int postOvulationLength = 8;
  bool pregnancyChance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0D31),
        title: const Text(
          'วัฏจักรและการตกไข่',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownRow(
              label: 'ระยะเวลารอบเดือน',
              value: cycleLength,
              items: List.generate(80, (index) => index + 21),
              onChanged: (newValue) {
                setState(() {
                  cycleLength = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownRow(
              label: 'ระยะเวลามีประจำเดือน',
              value: menstrualLength,
              items: List.generate(12, (index) => index + 1),
              onChanged: (newValue) {
                setState(() {
                  menstrualLength = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownRow(
              label: 'ระยะหลังไข่ตก',
              value: postOvulationLength,
              items: List.generate(10, (index) => index + 8),
              onChanged: (newValue) {
                setState(() {
                  postOvulationLength = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSwitchRow(
              label: 'โอกาสตั้งครรภ์',
              value: pregnancyChance,
              onChanged: (newValue) {
                setState(() {
                  pregnancyChance = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required int value,
    required List<int> items,
    required ValueChanged<int?> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        DropdownButton<int>(
          value: value,
          items: items
              .map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  color: Color(0xFF470606),
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF470606),
        ),
      ],
    );
  }
}

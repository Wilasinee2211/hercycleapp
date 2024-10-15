import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFFF6E3C5),  // Cream color
      unselectedItemColor: Colors.grey,
      backgroundColor: Color(0xFF470606),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'โฮม',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'ปฏิทิน',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'แจ้งเตือน',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'ตั้งค่า',
        ),
      ],
    );
  }
}

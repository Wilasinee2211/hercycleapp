import 'package:flutter/material.dart';
import 'contact_us_screen.dart'; // ลิงค์มาที่ไฟล์ contact_us_screen.dart

class HelpingScreen extends StatelessWidget {
  const HelpingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                color: const Color(0xFF0C0D31),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'ช่วยเหลือ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'How can HerCycle help you?',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0C0D31)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                          children: [
                            _buildGridItem('เริ่มต้น', 'assets/icon1.png'),
                            _buildGridItem('บัญชี', 'assets/icon2.png'),
                            _buildGridItem('ใช้งาน', 'assets/icon3.png'),
                            _buildGridItem('ส่วนตัว', 'assets/icon4.png'),
                            _buildGridItem('คำถามทั่วไป', 'assets/icon5.png'),
                            _buildGridItem('ปัญหา', 'assets/icon6.png'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF470606),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ContactUsScreen(),
                            ),
                          );
                        },
                        child: const Text('Contact us', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(String title, String iconPath) {
    return Card(
      elevation: 2,
      color: const Color(0xFFF6E3C5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0C0D31),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

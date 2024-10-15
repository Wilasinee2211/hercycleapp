import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0C0D31),
        title: Text(
          'กราฟและการรายงาน',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Image.asset(
              'assets/graph.png',
              height: 150,
            ),
            SizedBox(height: 20),
            buildReportOption(
              context,
              title: 'ระยะเวลารอบเดือน',
              subtitle: 'โดยเฉลี่ย 28 วัน',
              backgroundColor: Color(0xFFF6E3C5),
            ),
            buildReportOption(
              context,
              title: 'ระยะเวลามีประจำเดือน',
              subtitle: 'โดยเฉลี่ย 5 วัน',
              backgroundColor: Color(0xFFF6E3C5),
            ),
            buildSimpleButton(
              context,
              title: 'กราฟกิจกรรม',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Contact us',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFD3D3D3)), // Light text color
        ),
      ),
    );
  }

  Widget buildReportOption(BuildContext context, {required String title, required String subtitle, required Color backgroundColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C0D31),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0C0D31),
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward, color: Color(0xFF0C0D31)),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleButton(BuildContext context, {required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0C0D31),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFF0C0D31)),
          ),
        ),
        onPressed: () {
          // Handle navigation or actions for the 'กราฟกิจกรรม' option
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Color(0xFF0C0D31)),
            ),
            Icon(Icons.arrow_forward, color: Color(0xFF0C0D31)),
          ],
        ),
      ),
    );
  }
}

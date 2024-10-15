import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notidetail.dart';
import 'mednoti.dart';

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการแจ้งเตือนยา'),
        backgroundColor: Color(0xFF470606),
        foregroundColor: Color(0xFFF6E3C5),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!authSnapshot.hasData) {
            return Center(child: Text('กรุณาเข้าสู่ระบบเพื่อดูรายการแจ้งเตือนยา'));
          }
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(authSnapshot.data!.uid)
                .collection('medications')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Error fetching medications: ${snapshot.error}');
                return Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('ไม่พบรายการแจ้งเตือนยา'));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(data['medicineName'] ?? 'ไม่ระบุชื่อยา'),
                      subtitle: Text('เวลา: ${data['time'] ?? 'ไม่ระบุเวลา'}\nจานวน: ${data['pillsPerDay'] ?? 'ไม่ระบุ'} เม็ด/วัน'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedNoti(
                              medication: data,
                              documentId: document.id,
                            ),
                          ),
                        );
                        if (result == 'deleted') {
                          setState(() {
                            snapshot.data!.docs.removeAt(index);
                          });
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF0C0D31),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotiDetail()),
          );
        },
      ),
    );
  }
}
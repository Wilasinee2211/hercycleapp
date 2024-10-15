import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/period_firebase_service.dart';
import '../navigation/bottom_nav_bar.dart';
import 'menstrual_cycle_calendar.dart';
import 'settings_screen.dart';
import 'notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PeriodData? _periodData;
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPeriodData();
  }

  Future<void> _loadPeriodData() async {
    try {
      final data = await PeriodFirebaseService.getCurrentPeriodData();
      setState(() {
        _periodData = data;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading period data: $e');
      setState(() => _isLoading = false);
      _showErrorSnackBar('ไม่สามารถโหลดข้อมูลได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now(),
      locale: const Locale('th', 'TH'),
    );

    if (picked != null) {
      _logNewPeriod(picked);
    }
  }

  Future<void> _logNewPeriod(DateTime date) async {
    try {
      setState(() => _isLoading = true);
      await PeriodFirebaseService.logNewPeriod(date);
      await _loadPeriodData();
      _showSuccessSnackBar('บันทึกข้อมูลสำเร็จ');
    } catch (e) {
      print('Error logging new period: $e');
      _showErrorSnackBar('ไม่สามารถบันทึกข้อมูลได้ กรุณาลองใหม่อีกครั้ง');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', 'th').format(date);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Navigator logic based on currentIndex like in your old code
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenstrualCycleCalendar()),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 2) {
      // Navigate to NotificationScreen when index is 2
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      ).then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    } else if (index == 3) {
      Navigator.pushNamed(context, '/settings').then((_) {
        setState(() {
          _currentIndex = 0;
        });
      });
    }
  }

  Widget _buildContent() {
    if (_currentIndex == 0) {
      return _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildMainContent();
    } else if (_currentIndex == 1) {
      return const Center(
        child: Text('ปฏิทินกำลังพัฒนา...'),
      );
    } else if (_currentIndex == 2) {
      return const Center(
        child: Text('แจ้งเตือนกำลังพัฒนา...'),
      );
    } else if (_currentIndex == 3) {
      return const Center(
        child: Text('ตั้งค่ากำลังพัฒนา...'),
      );
    } else {
      return const Center(child: Text('หน้าที่คุณเลือกยังไม่พร้อมใช้งาน'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Her Cycle',
          style: TextStyle(color: Color(0xFFF6E3C5)),
        ),
        backgroundColor: const Color(0xFF470606),
        iconTheme: const IconThemeData(
          color: Color(0xFFF6E3C5), // กำหนดสีของไอคอนย้อนกลับเป็นสีขาว
        ),
      ),
      body: _buildContent(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
        onPressed: _showDatePicker,
        label: const Text(
          'บันทึกรอบเดือน',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF470606),
      )
          : null,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }

  Widget _buildMainContent() {
    if (_periodData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ยินดีต้อนรับ!\nกรุณาบันทึกข้อมูลรอบเดือนของคุณ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showDatePicker,
              icon: const Icon(Icons.calendar_today, color: Colors.white), // สีของไอคอน
              label: const Text(
                'เลือกวันที่เริ่มรอบเดือน',
                style: TextStyle(color: Colors.white), // สีของข้อความ
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF470606),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )

          ],
        ),
      );
    }

    final nextPeriod = PeriodFirebaseService.calculateNextPeriod(_periodData!);
    final fertileWindow = PeriodFirebaseService.calculateFertileWindow(_periodData!);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCircularPeriodCard(),
        const SizedBox(height: 16),
        _buildInfoCard(
          'ข้อมูลรอบเดือน',
          [
            _buildInfoRow('รอบเดือนครั้งล่าสุด', _formatDate(_periodData!.lastPeriodStart)),
            _buildInfoRow('รอบเดือนครั้งต่อไป (คาดการณ์)', _formatDate(nextPeriod)),
          ],
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          'ช่วงมีโอกาสตั้งครรภ์สูง',
          [
            _buildInfoRow('ช่วงเวลา', '${_formatDate(fertileWindow.first)} - ${_formatDate(fertileWindow.last)}'),
          ],
        ),
        if (_periodData!.symptoms != null && _periodData!.symptoms!.isNotEmpty)
          _buildSymptomsCard(),
        if (_periodData!.notes != null && _periodData!.notes!.isNotEmpty)
          _buildNotesCard(),
      ],
    );
  }

  Widget _buildCircularPeriodCard() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              Colors.pinkAccent.withOpacity(0.2),
              Colors.pinkAccent,
              Colors.pinkAccent.withOpacity(0.2),
            ],
            stops: [0.7, 0.9, 1],
            startAngle: 0.0,
            endAngle: 3.14 * 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'รอบเดือนถัดไปใน',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                '3 วัน',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Color(0xFF470606),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _showDatePicker,
                child: const Text(
                  '+ บันทึกรอบเดือน',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.pinkAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Color(0xFF470606),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomsCard() {
    return _buildInfoCard(
      'อาการที่บันทึก',
      _periodData!.symptoms!.map((symptom) => Text(symptom)).toList(),
    );
  }

  Widget _buildNotesCard() {
    return _buildInfoCard(
      'โน้ต',
      [_periodData!.notes != null ? Text(_periodData!.notes!) : Container()],
    );
  }
}

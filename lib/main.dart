import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/menstrual_cycle_calendar.dart';
import 'screens/notification/notification_screen.dart';
import 'screens/notification/notidetail.dart';
import 'screens/notification/mednoti.dart';
import 'screens/notification/medicationlistscreen.dart';
import 'services/firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCDYhxQl29tXuShj8j1lXumgmL0LJOTPuc",
      appId: "709812336053:android:89b17ae0b82a1d543f95fc",
      messagingSenderId: "709812336053",
      projectId: "hercycle-e804f",
    ),
  );

  await initializeDateFormatting('th', null);

  runApp(const HerCycleApp());
}

class HerCycleApp extends StatelessWidget {
  const HerCycleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HerCycle',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'YourCustomFont',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('th', ''), // Thai
        Locale('en', ''), // English
      ],
      locale: const Locale('th', ''),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/calendar': (context) => MenstrualCycleCalendar(),
        '/notification_screen': (context) => NotificationScreen(),
        '/notidetail': (context) => NotiDetail(),
        '/medication_list': (context) => MedicationListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/mednoti') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MedNoti(
              medication: args['medication'],
              documentId: args['documentId'],
            ),
          );
        }
        return null;
      },
    );
  }
}
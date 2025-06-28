import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_tab.dart';
import 'screens/send_money_tab.dart';
import 'screens/history_tab.dart';
import 'screens/fraud_tab.dart' as fraud;

void main() {
  runApp(const FraudXApp());
}

class FraudXApp extends StatelessWidget {
  const FraudXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FraudX',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        
        '/dashboard': (context) => const DashboardScreen(),
        '/home': (context) => const HomeTab(),
        '/send': (context) => const SendMoneyTab(),
        '/history': (context) => const HistoryTab(),
        '/fraud': (context) => const fraud.FraudTab(),
      },
    );
  }
}


// 📁 lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'send_money_tab.dart';
import 'history_tab.dart';
import 'fraud_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const SendMoneyTab(),
    const HistoryTab(),
    const FraudTab(),
  ];

  final List<String> _titles = [
    'Home',
    'Send Money',
    'History',
    'Fraud Alerts',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.indigo,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Send'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Fraud'),
        ],
      ),
    );
  }
}


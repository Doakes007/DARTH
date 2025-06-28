import 'package:flutter/material.dart';
import 'home_tab.dart';
import 'transactions_tab.dart';
import 'fraud_tab.dart';
import 'admin_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const TransactionsTab(),
    const FraudTab(),
    const AdminTab(),
  ];

  final List<String> _titles = [
    'Home',
    'Transactions',
    'Fraud Alerts',
    'Admin Stats',
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Fraud'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Admin'),
        ],
      ),
    );
  }
}


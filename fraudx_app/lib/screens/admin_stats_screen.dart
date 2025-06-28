import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminStatsScreen extends StatefulWidget {
  @override
  _AdminStatsScreenState createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  void _fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.getAdminStats();
      setState(() => _stats = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStat(String label, dynamic value, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.all(12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(label),
        trailing: Text("$value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildStat("Total Users", _stats["total_users"], Icons.people, Colors.blue),
                _buildStat("Total Transactions", _stats["total_transactions"], Icons.swap_horiz, Colors.green),
                _buildStat("Total Fraud Cases", _stats["total_frauds"], Icons.warning, Colors.red),
              ],
            ),
    );
  }
}


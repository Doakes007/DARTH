import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userId = globalUserId;
    if (userId != null) {
      final result = await ApiService.getUser(userId);
      setState(() {
        user = result;
      });
    }
  }

  Color _riskColor(String risk) {
    switch (risk.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FraudX Profile")),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Name: ${user!['name']}"),
                      Text("Email: ${user!['email']}"),
                      const SizedBox(height: 10),
                      Chip(
                        label: Text("Risk: ${user!['risk_level']}"),
                        backgroundColor: _riskColor(user!['risk_level']),
                        labelStyle: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}


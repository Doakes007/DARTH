import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map<String, dynamic>? user;
  double _userBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchBalance();
  }

  Future<void> _fetchUser() async {
    if (globalUserId != null) {
      final result = await ApiService.getUser(globalUserId!);
      setState(() {
        user = result;
      });
    }
  }

  Future<void> _fetchBalance() async {
    if (globalUserId != null) {
      double balance = await ApiService.getBalance(globalUserId!);
      setState(() {
        _userBalance = balance;
      });
    }
  }

  Color _getRiskColor(String risk) {
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
    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  margin: const EdgeInsets.all(20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Welcome, ${user!['name']}",
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Email: ${user!['email']}"),
                        const SizedBox(height: 10),
                        Text("Balance: ₹${_userBalance.toStringAsFixed(2)}"),
                        const SizedBox(height: 20),
                        Chip(
                          label: Text("Risk Level: ${user!['risk_level']}"),
                          backgroundColor: _getRiskColor(user!['risk_level']),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _fetchBalance();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text("Check Balance"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ApiService.logout();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
  }
}


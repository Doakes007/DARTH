import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FraudTab extends StatefulWidget {
  const FraudTab({super.key});

  @override
  State<FraudTab> createState() => _FraudTabState();
}

class _FraudTabState extends State<FraudTab> {
  List<dynamic> frauds = [];

  @override
  void initState() {
    super.initState();
    _fetchFrauds();
  }

  Future<void> _fetchFrauds() async {
    if (globalUserId != null) {
      final result = await ApiService.getFraud(globalUserId!);
      setState(() {
        frauds = result["frauds"] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return frauds.isEmpty
        ? const Center(child: Text("🎉 No fraud transactions detected!"))
        : ListView.builder(
            itemCount: frauds.length,
            itemBuilder: (context, index) {
              final txn = frauds[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  title: Text("Fraud: ₹${txn['amount'].toStringAsFixed(2)} to ${txn['to_id']}"),
                  subtitle: Text("Type: ${txn['type']} | Step: ${txn['step']}"),
                  trailing: Text(txn['timestamp'] ?? "", style: const TextStyle(fontSize: 12)),
                ),
              );
            },
          );
  }
}


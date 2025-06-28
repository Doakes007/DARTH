// 📁 lib/screens/history_tab.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    if (globalUserId != null) {
      final result = await ApiService.getHistory(globalUserId!);
      setState(() {
        transactions = result["transactions"] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(child: Text("No transactions yet."))
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    txn['is_fraud'] ? Icons.warning : Icons.check_circle,
                    color: txn['is_fraud'] ? Colors.red : Colors.green,
                  ),
                  title: Text("₹${txn['amount'].toStringAsFixed(2)} to ${txn['to_id']}"),
                  subtitle: Text("Type: ${txn['type']} | Step: ${txn['step']}"),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        txn['is_fraud'] ? "FRAUD" : "SAFE",
                        style: TextStyle(
                          color: txn['is_fraud'] ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(txn['timestamp'] ?? "", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          );
  }
}


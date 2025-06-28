// 📁 lib/screens/send_money_tab.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SendMoneyTab extends StatefulWidget {
  const SendMoneyTab({super.key});

  @override
  State<SendMoneyTab> createState() => _SendMoneyTabState();
}

class _SendMoneyTabState extends State<SendMoneyTab> {
  final TextEditingController _toIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String responseMessage = "";

  Future<void> _submitTransfer() async {
    final toId = int.tryParse(_toIdController.text);
    final amount = double.tryParse(_amountController.text);

    if (toId == null || amount == null || globalUserId == null) {
      setState(() => responseMessage = "Invalid input");
      return;
    }

    final payload = {
      "from_id": globalUserId,
      "to_id": toId,
      "amount": amount,
      "type": "TRANSFER",
      "step": 1,
      "oldbalanceOrg": 0.0,
      "newbalanceOrig": 0.0,
      "oldbalanceDest": 0.0,
      "newbalanceDest": 0.0
    };

    final res = await ApiService.sendMoney(payload);
    setState(() => responseMessage = res.containsKey('is_fraud')
        ? (res['is_fraud'] ? "⚠️ Fraud detected!" : "✅ Safe transfer")
        : "❌ Failed to process transaction");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Send Money", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: _toIdController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Recipient User ID"),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: "Amount (₹)"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitTransfer,
            child: const Text("Send"),
          ),
          const SizedBox(height: 10),
          Text(responseMessage, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

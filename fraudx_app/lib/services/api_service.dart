import 'dart:convert';
import 'package:http/http.dart' as http;

String? globalToken;     // ✅ Linux-safe global token
int? globalUserId;       // ✅ Linux-safe global user ID

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      globalToken = body['token'];
      globalUserId = body['user']['id'];
      return body;
    } else {
      return {"error": jsonDecode(res.body)["error"]};
    }
  }

  // 🔓 LOGOUT
  static void logout() {
    globalToken = null;
    globalUserId = null;
  }

  // ✅ GET USER
  static Future<Map<String, dynamic>> getUser(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  // ✅ GET BALANCE
  static Future<double> getBalance(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/user/$userId/balance'),
      headers: {'Authorization': 'Bearer $globalToken'},
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['balance']?.toDouble() ?? 0.0;
    } else {
      return 0.0;
    }
  }

  // ✅ SEND MONEY (protected)
  static Future<Map<String, dynamic>> sendMoney(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/transaction/transfer'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $globalToken',
      },
      body: jsonEncode(data),
    );
    return jsonDecode(res.body);
  }

  // ✅ TRANSACTION HISTORY
  static Future<Map<String, dynamic>> getHistory(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/transaction/history/$userId'),
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  // ✅ FRAUD TRANSACTIONS
  static Future<Map<String, dynamic>> getFraud(int userId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/transaction/fraud/$userId'),
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  // ✅ ADMIN STATS
  static Future<Map<String, dynamic>> getAdminStats() async {
    final res = await http.get(
      Uri.parse('$baseUrl/admin/stats'),
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }
}


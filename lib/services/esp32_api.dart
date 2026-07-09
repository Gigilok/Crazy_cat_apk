// ==========================================
// esp32_api.dart
// ==========================================
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ESP32Api {
  static const String baseUrl = 'http://192.168.4.1';
  static final ESP32Api _instance = ESP32Api._internal();
  factory ESP32Api() => _instance;
  ESP32Api._internal();

  Future<Map<String, dynamic>> getStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/status'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'error': 'Status ${response.statusCode}'};
    } catch (e) {
      return {'error': e.toString(), 'status': 'offline'};
    }
  }

  Future<List<Map<String, dynamic>>> scanNetworks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/redes'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['redes'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> startAttack(String type, int networkId, {int? packets}) async {
    try {
      final body = {
        'tipo': type,
        'rede_id': networkId,
        if (packets != null) 'pacotes': packets,
      };
      final response = await http.post(
        Uri.parse('$baseUrl/api/iniciar'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> stopAll() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/api/parar'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCapturedPassword() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/senha'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getHandshakes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/handshakes'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<String> getLog() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/log'))
          .timeout(const Duration(seconds: 5));
      final data = jsonDecode(response.body);
      return data['log'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<Map<String, dynamic>> getMITMStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/mitm'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getWPSStatus() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/wps'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

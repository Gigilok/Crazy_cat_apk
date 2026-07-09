// ==========================================
// esp32_api.dart - CORRIGIDO
// ==========================================
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ESP32API extends ChangeNotifier {
  static final ESP32API _instance = ESP32API._internal();
  factory ESP32API() => _instance;
  ESP32API._internal();

  String _baseUrl = 'http://${AppConstants.esp32DefaultIP}';
  String _lastError = '';
  bool _isLoading = false;

  String get baseUrl => _baseUrl;
  String get lastError => _lastError;
  bool get isLoading => _isLoading;

  void setBaseUrl(String ip) {
    _baseUrl = 'http://$ip';
    notifyListeners();
  }

  Future<Map<String, dynamic>> getStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('$_baseUrl${APIEndpoints.status}'))
          .timeout(const Duration(seconds: 5));
      _isLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return {'error': 'Status ${response.statusCode}'};
    } catch (e) {
      _isLoading = false;
      _lastError = e.toString();
      notifyListeners();
      return {'error': e.toString(), 'status': 'offline'};
    }
  }

  Future<List<Map<String, dynamic>>> scanNetworks() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl${APIEndpoints.redes}'))
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
        Uri.parse('$_baseUrl${APIEndpoints.iniciar}'),
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
      final response = await http.post(Uri.parse('$_baseUrl${APIEndpoints.parar}'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getCapturedPassword() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/senha'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getHandshakes() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/handshakes'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<String> getLog() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/log'))
          .timeout(const Duration(seconds: 5));
      final data = jsonDecode(response.body);
      return data['log'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<Map<String, dynamic>> getMITMStatus() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl${APIEndpoints.mitm}'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getWPSStatus() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl${APIEndpoints.wps}'))
          .timeout(const Duration(seconds: 5));
      return jsonDecode(response.body);
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

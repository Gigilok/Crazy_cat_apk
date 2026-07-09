import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../utils/constants.dart';

class WiFiService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();
  
  bool _isConnected = false;
  bool _isConnecting = false;
  String _esp32IP = AppConstants.esp32DefaultIP;
  String _localIP = '';
  String _wifiName = '';
  String _lastError = '';
  
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String get esp32IP => _esp32IP;
  String get localIP => _localIP;
  String get wifiName => _wifiName;
  String get lastError => _lastError;
  
  final StreamController<String> _logController = StreamController<String>.broadcast();
  Stream<String> get logStream => _logController.stream;
  
  WiFiService() {
    _init();
  }
  
  void _init() async {
    _connectivity.onConnectivityChanged.listen((result) {
      _checkConnection();
    });
    _checkConnection();
  }
  
  Future<void> _checkConnection() async {
    var result = await _connectivity.checkConnectivity();
    _isConnected = result == ConnectivityResult.wifi;
    
    if (_isConnected) {
      _localIP = await _networkInfo.getWifiIP() ?? '';
      _wifiName = await _networkInfo.getWifiName() ?? '';
      
      if (_wifiName.toLowerCase().contains('crazycat')) {
        _esp32IP = AppConstants.esp32DefaultIP;
      }
    }
    
    notifyListeners();
  }
  
  Future<bool> connectToESP32() async {
    return await testConnection(AppConstants.esp32DefaultIP);
  }
  
  Future<bool> testConnection(String ip) async {
    _isConnecting = true;
    _esp32IP = ip;
    notifyListeners();
    
    try {
      var response = await http.get(
        Uri.parse('http://$ip${APIEndpoints.status}'),
      ).timeout(AppConstants.connectionTimeout);
      
      if (response.statusCode == 200) {
        _isConnected = true;
        _lastError = '';
        _log('Connected to ESP32 at $ip');
        notifyListeners();
        return true;
      }
    } catch (e) {
      _lastError = 'Connection failed: $e';
      _log(_lastError);
    }
    
    _isConnecting = false;
    notifyListeners();
    return false;
  }
  
  Future<dynamic> getStatus() async {
    return await _get(APIEndpoints.status);
  }
  
  Future<dynamic> getNetworks() async {
    return await _get(APIEndpoints.redes);
  }
  
  Future<dynamic> getAttacks() async {
    return await _get(APIEndpoints.ataques);
  }
  
  Future<dynamic> startAttack(String type, int redeId, {int? pacotes}) async {
    Map<String, dynamic> body = {
      'tipo': type,
      'rede_id': redeId,
    };
    if (pacotes != null) body['pacotes'] = pacotes;
    
    return await _post(APIEndpoints.iniciar, body);
  }
  
  Future<dynamic> stopAttack() async {
    return await _post(APIEndpoints.parar, {});
  }
  
  Future<dynamic> getCapturedData() async {
    return await _get(APIEndpoints.dados);
  }
  
  Future<dynamic> _get(String endpoint) async {
    try {
      var response = await http.get(
        Uri.parse('http://$_esp32IP$endpoint'),
      ).timeout(AppConstants.commandTimeout);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      _log('GET error: $e');
    }
    return null;
  }
  
  Future<dynamic> _post(String endpoint, Map<String, dynamic> body) async {
    try {
      var response = await http.post(
        Uri.parse('http://$_esp32IP$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(AppConstants.commandTimeout);
      
      if (response.statusCode == 200) {
        _log('Command sent: ${jsonEncode(body)}');
        return jsonDecode(response.body);
      }
    } catch (e) {
      _log('POST error: $e');
    }
    return null;
  }
  
  void _log(String msg) {
    _logController.add('[${DateTime.now().toString().split('.')[0]}] $msg');
  }
  
  @override
  void dispose() {
    _logController.close();
    super.dispose();
  }
}

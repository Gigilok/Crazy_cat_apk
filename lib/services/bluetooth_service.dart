// ==========================================
// bluetooth_service.dart - CORRIGIDO
// Usa flutter_bluetooth_serial_ble: ^0.5.0
// ==========================================
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  FlutterBluetoothSerial? _bluetooth;
  BluetoothConnection? _connection;
  final StreamController<String> _responseController = StreamController<String>.broadcast();
  bool _isConnected = false;

  Stream<String> get responseStream => _responseController.stream;
  bool get isConnected => _isConnected;

  Future<List<BluetoothDevice>> scanDevices() async {
    _bluetooth ??= FlutterBluetoothSerial.instance;
    try {
      final bonded = await _bluetooth!.getBondedDevices();
      return bonded;
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      if (_connection!.isConnected) {
        _isConnected = true;
        _connection!.input!.listen((Uint8List data) {
          String response = utf8.decode(data);
          _responseController.add(response);
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      _connection!.output.add(Uint8List.fromList(utf8.encode('$command\r\n')));
      await _connection!.output.allSent;
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _connection?.close();
    _connection = null;
  }

  void dispose() {
    disconnect();
    _responseController.close();
  }
}

// ==========================================
// serial_service.dart
// ==========================================
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_usb_serial/flutter_usb_serial.dart';
import 'package:flutter/services.dart';

class SerialService {
  static final SerialService _instance = SerialService._internal();
  factory SerialService() => _instance;
  SerialService._internal();

  UsbPort? _port;
  StreamSubscription? _subscription;
  final StreamController<String> _responseController = StreamController<String>.broadcast();
  String _lastResponse = '';
  bool _isConnected = false;

  Stream<String> get responseStream => _responseController.stream;
  bool get isConnected => _isConnected;
  String get lastResponse => _lastResponse;

  Future<List<UsbDevice>> getAvailableDevices() async {
    try {
      return await FlutterUsbSerial.listDevices();
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(UsbDevice device, {int baudRate = 115200}) async {
    try {
      _port = await FlutterUsbSerial.create(device, baudRate);
      if (_port == null) return false;

      bool openResult = await _port!.open();
      if (!openResult) return false;

      await _port!.setDTR(true);
      await _port!.setRTS(true);
      await _port!.setPortParameters(
        baudRate,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      _subscription = _port!.inputStream!.listen((Uint8List data) {
        String response = utf8.decode(data);
        _lastResponse = response;
        _responseController.add(response);
      });

      _isConnected = true;
      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  Future<void> sendCommand(String command) async {
    if (_port == null || !_isConnected) return;
    Uint8List data = Uint8List.fromList(utf8.encode('$command\r\n'));
    await _port!.write(data);
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _subscription?.cancel();
    _subscription = null;
    await _port?.close();
    _port = null;
  }

  void dispose() {
    disconnect();
    _responseController.close();
  }
}

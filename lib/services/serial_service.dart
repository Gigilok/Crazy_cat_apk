// ==========================================
// serial_service.dart - CORRIGIDO
// Usa usb_serial: ^0.5.2 (nao flutter_usb_serial)
// ==========================================
import 'dart:async';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

class SerialService {
  static final SerialService _instance = SerialService._internal();
  factory SerialService() => _instance;
  SerialService._internal();

  UsbPort? _port;
  StreamSubscription? _subscription;
  Transaction<String>? _transaction;
  final StreamController<String> _responseController = StreamController<String>.broadcast();
  String _lastResponse = '';
  bool _isConnected = false;

  Stream<String> get responseStream => _responseController.stream;
  bool get isConnected => _isConnected;
  String get lastResponse => _lastResponse;

  Future<List<UsbDevice>> getAvailableDevices() async {
    try {
      return await UsbSerial.listDevices();
    } catch (e) {
      return [];
    }
  }

  Future<bool> connect(UsbDevice device, {int baudRate = 115200}) async {
    try {
      _port = await device.create();
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

      // Usa Transaction para leitura de linhas
      _transaction = Transaction.stringTerminated(
        _port!.inputStream!,
        Uint8List.fromList([13, 10]), // \r\n
      );

      _subscription = _transaction!.stream.listen((String response) {
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
    Uint8List data = Uint8List.fromList('$command\r\n'.codeUnits);
    await _port!.write(data);
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _subscription?.cancel();
    _subscription = null;
    _transaction?.dispose();
    _transaction = null;
    await _port?.close();
    _port = null;
  }

  void dispose() {
    disconnect();
    _responseController.close();
  }
}

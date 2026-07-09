import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothService extends ChangeNotifier {
  final FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  
  BluetoothState _state = BluetoothState.UNKNOWN;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _connectedDevice;
  
  bool _isScanning = false;
  bool _isConnecting = false;
  String _lastResponse = '';
  StreamSubscription? _dataSubscription;
  
  // Getters
  BluetoothState get state => _state;
  bool get isEnabled => _state == BluetoothState.STATE_ON;
  bool get isConnected => _connection?.isConnected ?? false;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  List<BluetoothDevice> get devices => _devices;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String get lastResponse => _lastResponse;
  
  // Stream controller para dados recebidos
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataController.stream;
  
  BluetoothService() {
    _init();
  }
  
  void _init() async {
    _state = await _bluetooth.state;
    _bluetooth.onStateChanged().listen((s) {
      _state = s;
      notifyListeners();
    });
    notifyListeners();
  }
  
  Future<bool> enable() async {
    return await _bluetooth.requestEnable() ?? false;
  }
  
  Future<void> scanDevices() async {
    if (_isScanning) return;
    _isScanning = true;
    _devices = [];
    notifyListeners();
    
    try {
      await _bluetooth.startDiscovery().listen((result) {
        if (!_devices.any((d) => d.address == result.device.address)) {
          _devices.add(result.device);
          notifyListeners();
        }
      }).asFuture();
    } catch (e) {
      debugPrint('Scan error: $e');
    }
    
    _isScanning = false;
    notifyListeners();
  }
  
  Future<bool> connect(BluetoothDevice device) async {
    _isConnecting = true;
    notifyListeners();
    
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      _connectedDevice = device;
      _isConnecting = false;
      
      _dataSubscription = _connection!.input!.listen((data) {
        String response = utf8.decode(data);
        _lastResponse = response;
        _dataController.add(response);
        notifyListeners();
      });
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Connection error: $e');
      _isConnecting = false;
      notifyListeners();
      return false;
    }
  }
  
  Future<void> disconnect() async {
    await _dataSubscription?.cancel();
    await _connection?.dispose();
    _connection = null;
    _connectedDevice = null;
    notifyListeners();
  }
  
  Future<void> sendCommand(String command) async {
    if (!isConnected) return;
    
    String cmd = command.trim();
    if (!cmd.endsWith('\n')) cmd += '\n';
    
    Uint8List data = utf8.encode(cmd) as Uint8List;
    _connection!.output.add(data);
    await _connection!.output.allSent;
  }
  
  @override
  void dispose() {
    _dataSubscription?.cancel();
    _connection?.dispose();
    _dataController.close();
    super.dispose();
  }
}


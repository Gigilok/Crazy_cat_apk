import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_usb_serial/flutter_usb_serial.dart';

class SerialService extends ChangeNotifier {
  UsbPort? _port;
  List<UsbDevice> _devices = [];
  bool _isConnected = false;
  bool _isScanning = false;
  String _lastResponse = '';
  
  // Getters
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  List<UsbDevice> get devices => _devices;
  String get lastResponse => _lastResponse;
  
  final StreamController<String> _dataController = StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataController.stream;
  
  Future<void> scanDevices() async {
    _isScanning = true;
    notifyListeners();
    
    try {
      _devices = await FlutterUsbSerial.listDevices();
    } catch (e) {
      debugPrint('USB scan error: $e');
    }
    
    _isScanning = false;
    notifyListeners();
  }
  
  Future<bool> connect(UsbDevice device) async {
    try {
      _port = await FlutterUsbSerial.createFromDeviceId(device.deviceId);
      if (_port == null) return false;
      
      bool openResult = await _port!.open();
      if (!openResult) return false;
      
      await _port!.setDTR(true);
      await _port!.setRTS(true);
      
      await _port!.setPortParameters(
        115200, // baudRate
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );
      
      _port!.inputStream!.listen((Uint8List data) {
        String response = utf8.decode(data);
        _lastResponse = response
          

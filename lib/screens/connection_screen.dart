// ==========================================
// connection_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart' as bt;
import '../models/connection_type.dart';
import '../services/bluetooth_service.dart';
import '../services/wifi_service.dart';
import '../services/serial_service.dart';
import 'dashboard_screen.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  AppConnectionType _selectedType = AppConnectionType.wifi;
  bool _isConnecting = false;
  String _status = 'Selecione o modo de conexão';

  final BluetoothService _btService = BluetoothService();
  final WiFiService _wifiService = WiFiService();
  final SerialService _serialService = SerialService();

  Future<void> _connect() async {
    setState(() {
      _isConnecting = true;
      _status = 'Conectando...';
    });

    bool connected = false;

    try {
      switch (_selectedType) {
        case AppConnectionType.bluetooth:
          _status = 'Buscando CrazyCat via Bluetooth...';
          setState(() {});
          final devices = await _btService.scanDevices();
          final target = devices.firstWhere(
            (d) => d.name?.contains('CrazyCat') ?? false,
            orElse: () => devices.isNotEmpty ? devices.first : bt.BluetoothDevice(address: ''),
          );
          if (devices.isNotEmpty && target.address.isNotEmpty) {
            connected = await _btService.connect(target);
          }
          break;

        case AppConnectionType.wifi:
          _status = 'Conectando ao AP CrazyCat (192.168.4.1)...';
          setState(() {});
          connected = await _wifiService.connectToESP32();
          break;

        case AppConnectionType.usbSerial:
          _status = 'Buscando dispositivo USB...';
          setState(() {});
          final devices = await _serialService.getAvailableDevices();
          if (devices.isNotEmpty) {
            connected = await _serialService.connect(devices.first);
          }
          break;
      }
    } catch (e) {
      _status = 'Erro: $e';
    }

    setState(() {
      _isConnecting = false;
      if (connected) {
        _status = 'Conectado!';
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              connectionType: _selectedType,
            ),
          ),
        );
      } else {
        _status = 'Falha na conexão. Tente novamente.';
      }
    });
  }

  Widget _buildConnectionCard(AppConnectionType type, String title,
      String subtitle, IconData icon, Color color) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withOpacity(0.7)])
              : null,
          color: isSelected ? null : const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 32),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0f0c29), Color(0xFF302b63), Color(0xFF24243e)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.pets, size: 60, color: Color(0xFF00ff00)),
              const SizedBox(height: 20),
              const Text(
                'CONECTAR AO ESP32',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00ff00),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _status,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildConnectionCard(
                AppConnectionType.wifi,
                'WiFi',
                'Conectar ao AP CrazyCat (192.168.4.1)',
                Icons.wifi,
                const Color(0xFF667eea),
              ),
              _buildConnectionCard(
                AppConnectionType.bluetooth,
                'Bluetooth',
                'Parear com CrazyCat via Serial BT',
                Icons.bluetooth,
                const Color(0xFF00b09b),
              ),
              _buildConnectionCard(
                AppConnectionType.usbSerial,
                'USB Serial',
                'Conectar via cabo USB OTG',
                Icons.usb,
                const Color(0xFFff416c),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isConnecting ? null : _connect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: _isConnecting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'CONECTAR',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

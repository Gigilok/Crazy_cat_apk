// ==========================================
// dashboard_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../models/connection_type.dart';
import 'rf_tools_screen.dart';
import 'wireless_tools_screen.dart';
import 'attack_tools_screen.dart';
import 'camera_hacker_screen.dart';
import 'signal_manager_screen.dart';
import 'settings_screen.dart';
import 'terminal_screen.dart';

class DashboardScreen extends StatefulWidget {
  final ConnectionType connectionType;

  const DashboardScreen({super.key, required this.connectionType});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _tools = [
    {
      'title': 'RF Tools',
      'icon': Icons.settings_input_antenna,
      'color': Color(0xFF667eea),
      'description': 'CC1101, NRF24, SubGHz database, Jammer, Replay',
      'screen': RFToolsScreen(),
    },
    {
      'title': 'Wireless',
      'icon': Icons.wifi_tethering,
      'color': Color(0xFF00b09b),
      'description': 'WiFi Scan, Evil Twin, Deauth, Handshake, WPS',
      'screen': WirelessToolsScreen(),
    },
    {
      'title': 'Attacks',
      'icon': Icons.warning_amber,
      'color': Color(0xFFff416c),
      'description': 'Deauth, Beacon Flood, Probe Flood, Random SSID',
      'screen': AttackToolsScreen(),
    },
    {
      'title': 'Camera Hacker',
      'icon': Icons.videocam,
      'color': Color(0xFFf093fb),
      'description': 'Buscar e acessar cameras IP Dahua/Hikvision/Intelbras',
      'screen': CameraHackerScreen(),
    },
    {
      'title': 'Signal Manager',
      'icon': Icons.save,
      'color': Color(0xFF4facfe),
      'description': 'Gerenciar sinais salvos, exportar/importar',
      'screen': SignalManagerScreen(),
    },
    {
      'title': 'Terminal',
      'icon': Icons.terminal,
      'color': Color(0xFF43e97b),
      'description': 'Console serial para comandos diretos',
      'screen': TerminalScreen(),
    },
    {
      'title': 'Settings',
      'icon': Icons.settings,
      'color': Color(0xFFfa709a),
      'description': 'Configuracoes do dispositivo',
      'screen': SettingsScreen(),
    },
  ];

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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pets, color: Color(0xFF00ff00), size: 28),
                    const SizedBox(width: 10),
                    const Text(
                      'CRAZYCAT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00ff00),
                        letterSpacing: 2,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00ff00).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00ff00)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.connectionType == ConnectionType.wifi
                                ? Icons.wifi
                                : widget.connectionType ==
                                        ConnectionType.bluetooth
                                    ? Icons.bluetooth
                                    : Icons.usb,
                            color: const Color(0xFF00ff00),
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            widget.connectionType == ConnectionType.wifi
                                ? 'WiFi'
                                : widget.connectionType ==
                                        ConnectionType.bluetooth
                                    ? 'BT'
                                    : 'USB',
                            style: const TextStyle(
                              color: Color(0xFF00ff00),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Selecione uma ferramenta',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _tools.length,
                  itemBuilder: (context, index) {
                    final tool = _tools[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => tool['screen'] as Widget),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a2e),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: (tool['color'] as Color).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    tool['color'] as Color,
                                    (tool['color'] as Color).withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                tool['icon'] as IconData,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tool['title'] as String,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    tool['description'] as String,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Colors.white54),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

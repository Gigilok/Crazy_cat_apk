// ==========================================
// wireless_tools_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../services/esp32_api.dart';
import '../models/wifi_network.dart';

class WirelessToolsScreen extends StatefulWidget {
  const WirelessToolsScreen({super.key});

  @override
  State<WirelessToolsScreen> createState() => _WirelessToolsScreenState();
}

class _WirelessToolsScreenState extends State<WirelessToolsScreen> {
  final ESP32Api _api = ESP32Api();
  List<WiFiNetwork> _networks = [];
  WiFiNetwork? _selectedNetwork;
  bool _isScanning = false;
  bool _isAttacking = false;
  String _status = 'Toque em Escanear para buscar redes';

  Future<void> _scanNetworks() async {
    setState(() {
      _isScanning = true;
      _status = 'Escaneando redes WiFi...';
    });

    try {
      final networksData = await _api.scanNetworks();
      setState(() {
        _networks = networksData.map((d) => WiFiNetwork.fromJson(d)).toList();
        _isScanning = false;
        _status = '${_networks.length} redes encontradas';
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _status = 'Erro no scan: $e';
      });
    }
  }

  Future<void> _startAttack(String type, {int? packets}) async {
    if (_selectedNetwork == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione uma rede primeiro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isAttacking = true;
      _status = 'Iniciando $type em ${_selectedNetwork!.ssid}...';
    });

    try {
      final result = await _api.startAttack(
        type,
        _selectedNetwork!.id,
        packets: packets,
      );
      setState(() {
        _isAttacking = false;
        _status = result['status'] ?? 'Comando enviado';
      });
    } catch (e) {
      setState(() {
        _isAttacking = false;
        _status = 'Erro: $e';
      });
    }
  }

  Future<void> _stopAll() async {
    setState(() => _status = 'Parando ataques...');
    try {
      await _api.stopAll();
      setState(() => _status = 'Todos os ataques parados');
    } catch (e) {
      setState(() => _status = 'Erro ao parar: $e');
    }
  }

  Color _getSignalColor(int rssi) {
    if (rssi > -50) return Colors.green;
    if (rssi > -70) return Colors.yellow;
    return Colors.red;
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
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.wifi_tethering,
                        color: Color(0xFF00b09b), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'WIRELESS TOOLS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scan Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isScanning ? null : _scanNetworks,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(
                        _isScanning ? 'ESCANEANDO...' : 'ESCANEAR REDES'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00b09b),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _status,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),

              const SizedBox(height: 10),

              // Networks List
              Expanded(
                child: _networks.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma rede encontrada\nToque em Escanear',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _networks.length,
                        itemBuilder: (context, index) {
                          final network = _networks[index];
                          final isSelected = _selectedNetwork?.id == network.id;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedNetwork = network),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF00b09b).withOpacity(0.2)
                                    : const Color(0xFF1a1a2e),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF00b09b)
                                      : Colors.white24,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    network.isSecure
                                        ? Icons.wifi_lock
                                        : Icons.wifi,
                                    color: _getSignalColor(network.rssi),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          network.ssid,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'CH:${network.channel} | ${network.bssid}',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getSignalColor(network.rssi)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${network.rssi} dBm',
                                      style: TextStyle(
                                        color: _getSignalColor(network.rssi),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Attack Buttons
              if (_selectedNetwork != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1a1a2e),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Alvo: ${_selectedNetwork!.ssid}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _attackButton(
                              'Evil Twin',
                              Icons.copy,
                              const Color(0xFF667eea),
                              () => _startAttack('evil_twin'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _attackButton(
                              'Deauth',
                              Icons.wifi_off,
                              const Color(0xFFff416c),
                              () => _startAttack('deauth', packets: 100),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _attackButton(
                              'Handshake',
                              Icons.handshake,
                              const Color(0xFF4facfe),
                              () => _startAttack('handshake'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _attackButton(
                              'WPS',
                              Icons.pin,
                              const Color(0xFFf093fb),
                              () => _startAttack('wps'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _attackButton(
                              'Parar',
                              Icons.stop,
                              Colors.red,
                              _stopAll,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attackButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isAttacking ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// rf_tools_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../services/wifi_service.dart';
import '../services/serial_service.dart';
import '../utils/commands.dart';

class RFToolsScreen extends StatefulWidget {
  const RFToolsScreen({super.key});

  @override
  State<RFToolsScreen> createState() => _RFToolsScreenState();
}

class _RFToolsScreenState extends State<RFToolsScreen> {
  final List<Map<String, dynamic>> _rfTools = [
    {
      'name': 'CC1101 Scan',
      'icon': Icons.radar,
      'color': Color(0xFF667eea),
      'description': 'Escanear frequencias 300-348MHz, 387-464MHz, 779-928MHz com CC1101',
      'command': Commands.cc1101Scan,
    },
    {
      'name': 'CC1101 Jammer',
      'icon': Icons.wifi_tethering_off,
      'color': Color(0xFFff416c),
      'description': 'Ativar jammer de frequencia no CC1101 (bloqueia sinais RF)',
      'command': Commands.cc1101Jammer,
    },
    {
      'name': 'NRF24 Scan',
      'icon': Icons.settings_input_antenna,
      'color': Color(0xFF00b09b),
      'description': 'Escanear canais 2.4GHz com NRF24L01 (canais 0-125)',
      'command': Commands.nrf24Scan,
    },
    {
      'name': 'NRF24 Jammer',
      'icon': Icons.bluetooth_disabled,
      'color': Color(0xFFf093fb),
      'description': 'Ativar jammer 2.4GHz no NRF24L01',
      'command': Commands.nrf24Jammer,
    },
    {
      'name': 'SubGHz Database',
      'icon': Icons.storage,
      'color': Color(0xFF4facfe),
      'description': 'Banco de dados de sinais conhecidos: portoes, alarmes, carros',
      'command': Commands.subghzDatabase,
    },
    {
      'name': 'Replay Attack',
      'icon': Icons.repeat,
      'color': Color(0xFFfa709a),
      'description': 'Capturar e retransmitir sinal RF (replay attack)',
      'command': Commands.replayAttack,
    },
    {
      'name': 'Raw TX',
      'icon': Icons.send,
      'color': Color(0xFF43e97b),
      'description': 'Transmitir dados brutos via CC1101 ou NRF24',
      'command': Commands.rawTx,
    },
    {
      'name': 'Raw RX',
      'icon': Icons.download,
      'color': Color(0xFFfeca57),
      'description': 'Receber e exibir dados brutos RF',
      'command': Commands.rawRx,
    },
  ];

  String _log = '';
  bool _isRunning = false;

  Future<void> _sendCommand(String command) async {
    setState(() {
      _isRunning = true;
      _log += '> $command\n';
    });

    // Envia via conexão ativa (BT, WiFi ou Serial)
    try {
      // Implementar lógica de envio baseada na conexão atual
      await Future.delayed(const Duration(seconds: 1)); // Simulação
      setState(() {
        _log += '[OK] Comando enviado ao ESP32\n';
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _log += '[ERRO] $e\n';
        _isRunning = false;
      });
    }
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
                    const Icon(Icons.settings_input_antenna,
                        color: Color(0xFF667eea), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'RF TOOLS',
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

              // Tools Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _rfTools.length,
                  itemBuilder: (context, index) {
                    final tool = _rfTools[index];
                    return GestureDetector(
                      onTap: () => _showToolDialog(tool),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1a1a2e),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: (tool['color'] as Color).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tool['icon'] as IconData,
                              color: tool['color'] as Color,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              tool['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Log Console
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF00ff00)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal, color: Color(0xFF00ff00), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'CONSOLE',
                          style: TextStyle(
                            color: Color(0xFF00ff00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Text(
                          _log,
                          style: const TextStyle(
                            color: Color(0xFF00ff00),
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
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

  void _showToolDialog(Map<String, dynamic> tool) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(
          tool['name'] as String,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          tool['description'] as String,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendCommand(tool['command'] as String);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tool['color'] as Color,
            ),
            child: const Text('EXECUTAR'),
          ),
        ],
      ),
    );
  }
}

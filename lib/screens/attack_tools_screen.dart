// ==========================================
// attack_tools_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../services/esp32_api.dart';

class AttackToolsScreen extends StatefulWidget {
  const AttackToolsScreen({super.key});

  @override
  State<AttackToolsScreen> createState() => _AttackToolsScreenState();
}

class _AttackToolsScreenState extends State<AttackToolsScreen> {
  final ESP32Api _api = ESP32Api();
  final List<Map<String, dynamic>> _attacks = [
    {
      'name': 'Deauth Flood',
      'icon': Icons.wifi_off,
      'color': Color(0xFFff416c),
      'description': 'Enviar pacotes de deautenticacao massivos para desconectar todos os clientes',
      'type': 'deauth_flood',
      'danger': 'ALTO',
    },
    {
      'name': 'Beacon Flood',
      'icon': Icons.cell_tower,
      'color': Color(0xFFf093fb),
      'description': 'Criar milhares de APs falsos (SSID flood) para sobrecarregar scanners',
      'type': 'beacon_flood',
      'danger': 'MEDIO',
    },
    {
      'name': 'Probe Flood',
      'icon': Icons.radar,
      'color': Color(0xFFfa709a),
      'description': 'Enviar probes requests massivos para confundir sistemas de deteccao',
      'type': 'probe_flood',
      'danger': 'MEDIO',
    },
    {
      'name': 'Random SSID',
      'icon': Icons.shuffle,
      'color': Color(0xFF43e97b),
      'description': 'Criar APs com SSIDs aleatorios e ofensivos',
      'type': 'random_ssid',
      'danger': 'BAIXO',
    },
    {
      'name': 'Rickroll AP',
      'icon': Icons.music_note,
      'color': Color(0xFFfeca57),
      'description': 'Criar APs com nomes de musicas do Rick Astley',
      'type': 'rickroll',
      'danger': 'BAIXO',
    },
    {
      'name': 'AP Clone',
      'icon': Icons.copy,
      'color': Color(0xFF4facfe),
      'description': 'Clonar APs proximos para confundir usuarios',
      'type': 'ap_clone',
      'danger': 'MEDIO',
    },
  ];

  String _log = '';
  bool _isRunning = false;

  Future<void> _executeAttack(String type) async {
    setState(() {
      _isRunning = true;
      _log += '> Iniciando $type...\n';
    });

    try {
      // Simulação - implementar chamada real à API
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _log += '[OK] Ataque $type iniciado no ESP32\n';
        _isRunning = false;
      });
    } catch (e) {
      setState(() {
        _log += '[ERRO] $e\n';
        _isRunning = false;
      });
    }
  }

  Color _getDangerColor(String danger) {
    switch (danger) {
      case 'ALTO':
        return Colors.red;
      case 'MEDIO':
        return Colors.orange;
      default:
        return Colors.green;
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
                    const Icon(Icons.warning_amber,
                        color: Color(0xFFff416c), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'ATTACK TOOLS',
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

              // Warning
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Use apenas em redes que voce possui permissao. O uso indevido e crime.',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Attacks List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _attacks.length,
                  itemBuilder: (context, index) {
                    final attack = _attacks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a1a2e),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: (attack['color'] as Color).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                attack['icon'] as IconData,
                                color: attack['color'] as Color,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  attack['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getDangerColor(attack['danger'] as String)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: _getDangerColor(
                                        attack['danger'] as String),
                                  ),
                                ),
                                child: Text(
                                  attack['danger'] as String,
                                  style: TextStyle(
                                    color: _getDangerColor(
                                        attack['danger'] as String),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            attack['description'] as String,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: _isRunning
                                  ? null
                                  : () => _showAttackConfirm(attack),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: attack['color'] as Color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isRunning
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('EXECUTAR'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Console
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(12),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFff416c)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.terminal,
                            color: Color(0xFFff416c), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'ATTACK CONSOLE',
                          style: TextStyle(
                            color: Color(0xFFff416c),
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
                            color: Color(0xFFff416c),
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

  void _showAttackConfirm(Map<String, dynamic> attack) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Row(
          children: [
            Icon(Icons.warning, color: attack['color'] as Color),
            const SizedBox(width: 10),
            Text(
              attack['name'] as String,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          '${attack['description']}\n\nNivel de risco: ${attack['danger']}\n\nConfirma a execucao?',
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
              _executeAttack(attack['type'] as String);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: attack['color'] as Color,
            ),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }
}

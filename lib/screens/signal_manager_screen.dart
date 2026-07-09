// ==========================================
// signal_manager_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../models/rf_signal.dart';

class SignalManagerScreen extends StatefulWidget {
  const SignalManagerScreen({super.key});

  @override
  State<SignalManagerScreen> createState() => _SignalManagerScreenState();
}

class _SignalManagerScreenState extends State<SignalManagerScreen> {
  final List<RFSignal> _signals = [
    RFSignal(
      name: 'Portao Garagem',
      frequency: 433920000,
      modulation: 'ASK/OOK',
      rssi: -45,
      protocol: 'Fixed Code',
      rawData: [0xAB, 0xCD, 0xEF, 0x12],
    ),
    RFSignal(
      name: 'Alarme Casa',
      frequency: 315000000,
      modulation: 'FSK',
      rssi: -62,
      protocol: 'Rolling Code',
      rawData: [0x11, 0x22, 0x33, 0x44, 0x55],
    ),
    RFSignal(
      name: 'Controle TV',
      frequency: 433920000,
      modulation: 'ASK',
      rssi: -70,
      protocol: 'NEC',
      rawData: [0xFF, 0x00, 0xFF, 0x00],
    ),
  ];

  void _deleteSignal(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
        content: Text(
          'Excluir "${_signals[index].name}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _signals.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('EXCLUIR'),
          ),
        ],
      ),
    );
  }

  void _transmitSignal(RFSignal signal) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transmitindo: ${signal.name} @ ${signal.frequency}Hz'),
        backgroundColor: const Color(0xFF4facfe),
      ),
    );
  }

  void _exportSignals() {
    // Exportar para arquivo JSON/CSV
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sinais exportados para /sdcard/crazycat/signals.json'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _importSignals() {
    // Importar de arquivo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Importacao nao implementada nesta versao'),
        backgroundColor: Colors.orange,
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
                    const Icon(Icons.save, color: Color(0xFF4facfe), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'SIGNAL MANAGER',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _exportSignals,
                      icon: const Icon(Icons.download, color: Colors.white),
                      tooltip: 'Exportar',
                    ),
                    IconButton(
                      onPressed: _importSignals,
                      icon: const Icon(Icons.upload, color: Colors.white),
                      tooltip: 'Importar',
                    ),
                  ],
                ),
              ),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _statCard('${_signals.length}', 'Sinais', const Color(0xFF4facfe)),
                    const SizedBox(width: 10),
                    _statCard('433.92', 'MHz Mais', const Color(0xFF00ff00)),
                    const SizedBox(width: 10),
                    _statCard('12KB', 'Tamanho', const Color(0xFFf093fb)),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Signals List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _signals.length,
                  itemBuilder: (context, index) {
                    final signal = _signals[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1a1a2e),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF4facfe).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4facfe).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.waves,
                                  color: Color(0xFF4facfe),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      signal.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${(signal.frequency / 1000000).toStringAsFixed(2)} MHz | ${signal.modulation}',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getRssiColor(signal.rssi)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${signal.rssi} dBm',
                                  style: TextStyle(
                                    color: _getRssiColor(signal.rssi),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _actionChip('Protocolo: ${signal.protocol}'),
                              const SizedBox(width: 8),
                              _actionChip('${signal.rawData.length} bytes'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _transmitSignal(signal),
                                  icon: const Icon(Icons.send, size: 16),
                                  label: const Text('TRANSMITIR'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4facfe),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => _deleteSignal(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
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

  Widget _statCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 11),
      ),
    );
  }

  Color _getRssiColor(int rssi) {
    if (rssi > -50) return Colors.green;
    if (rssi > -70) return Colors.yellow;
    return Colors.red;
  }
}

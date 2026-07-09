// ==========================================
// rf_tools_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../utils/commands.dart';
import '../utils/constants.dart';

class RFToolsScreen extends StatelessWidget {
  const RFToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'name': 'CC1101 Scanner', 'command': Commands.cc1101Scan, 'icon': Icons.radar},
      {'name': 'CC1101 Jammer', 'command': Commands.cc1101Jammer, 'icon': Icons.wifi_tethering},
      {'name': 'nRF24 Scanner', 'command': Commands.nrf24Scan, 'icon': Icons.blur_on},
      {'name': 'nRF24 Jammer', 'command': Commands.nrf24Jammer, 'icon': Icons.wifi_tethering_error},
      {'name': 'Sub-GHz DB', 'command': Commands.subghzDatabase, 'icon': Icons.storage},
      {'name': 'Replay Attack', 'command': Commands.replayAttack, 'icon': Icons.replay},
      {'name': 'Raw TX', 'command': Commands.rawTx, 'icon': Icons.send},
      {'name': 'Raw RX', 'command': Commands.rawRx, 'icon': Icons.receipt},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RF TOOLS'),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Icon(tool['icon'] as IconData, color: AppColors.primary),
              title: Text(
                tool['name'] as String,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
              subtitle: Text(
                'Command: ${tool['command']}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enviando: ${tool['command']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

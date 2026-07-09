import 'package:flutter/material.dart';
import '../models/connection_type.dart';

class StatusBar extends StatelessWidget {
  final ConnectionType connectionType;
  final bool isConnected;

  const StatusBar({
    super.key,
    required this.connectionType,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isConnected ? const Color(0xFF00ff00) : Colors.red,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            connectionType == ConnectionType.wifi
                ? Icons.wifi
                : connectionType == ConnectionType.bluetooth
                    ? Icons.bluetooth
                    : Icons.usb,
            color: isConnected ? const Color(0xFF00ff00) : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isConnected ? 'CONECTADO' : 'DESCONECTADO',
            style: TextStyle(
              color: isConnected ? const Color(0xFF00ff00) : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

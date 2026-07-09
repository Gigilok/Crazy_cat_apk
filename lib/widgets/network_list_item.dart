import 'package:flutter/material.dart';
import '../models/wifi_network.dart';

class NetworkListItem extends StatelessWidget {
  final WiFiNetwork network;
  final bool isSelected;
  final VoidCallback onTap;

  const NetworkListItem({
    super.key,
    required this.network,
    required this.isSelected,
    required this.onTap,
  });

  Color _getSignalColor(int rssi) {
    if (rssi > -50) return Colors.green;
    if (rssi > -70) return Colors.yellow;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00b09b).withOpacity(0.2)
              : const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF00b09b) : Colors.white24,
          ),
        ),
        child: Row(
          children: [
            Icon(
              network.isSecure ? Icons.wifi_lock : Icons.wifi,
              color: _getSignalColor(network.rssi),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getSignalColor(network.rssi).withOpacity(0.2),
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
  }
}

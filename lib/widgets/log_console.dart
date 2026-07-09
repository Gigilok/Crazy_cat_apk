import 'package:flutter/material.dart';

class LogConsole extends StatelessWidget {
  final String log;
  final Color accentColor;
  final String title;

  const LogConsole({
    super.key,
    required this.log,
    this.accentColor = const Color(0xFF00ff00),
    this.title = 'CONSOLE',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(12),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: accentColor, size: 14),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: accentColor,
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
                log,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

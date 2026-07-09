// ==========================================
// settings_screen.dart
// ==========================================
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _autoConnect = true;
  bool _notifications = true;
  String _selectedBaudRate = '115200';
  String _selectedTheme = 'Cyberpunk';

  final List<String> _baudRates = ['9600', '19200', '38400', '57600', '115200', '230400'];
  final List<String> _themes = ['Cyberpunk', 'Matrix', 'Dark', 'Light'];

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
                    const Icon(Icons.settings, color: Color(0xFFfa709a), size: 28),
                    const SizedBox(width: 10),
                    const Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _sectionTitle('CONEXAO'),
                    _settingSwitch(
                      'Auto Conectar',
                      'Conectar automaticamente ao abrir o app',
                      Icons.autorenew,
                      _autoConnect,
                      (v) => setState(() => _autoConnect = v),
                    ),
                    _settingDropdown(
                      'Baud Rate',
                      'Velocidade da porta serial',
                      Icons.speed,
                      _selectedBaudRate,
                      _baudRates,
                      (v) => setState(() => _selectedBaudRate = v!),
                    ),

                    _sectionTitle('INTERFACE'),
                    _settingSwitch(
                      'Modo Escuro',
                      'Tema escuro para economia de bateria',
                      Icons.dark_mode,
                      _darkMode,
                      (v) => setState(() => _darkMode = v),
                    ),
                    _settingDropdown(
                      'Tema',
                      'Estilo visual do aplicativo',
                      Icons.palette,
                      _selectedTheme,
                      _themes,
                      (v) => setState(() => _selectedTheme = v!),
                    ),

                    _sectionTitle('NOTIFICACOES'),
                    _settingSwitch(
                      'Notificacoes',
                      'Alertas quando senhas forem capturadas',
                      Icons.notifications,
                      _notifications,
                      (v) => setState(() => _notifications = v),
                    ),

                    _sectionTitle('DISPOSITIVO'),
                    _settingButton(
                      'Reiniciar ESP32',
                      'Enviar comando de reset ao ESP32',
                      Icons.restart_alt,
                      Colors.orange,
                      () => _showConfirm('Reiniciar ESP32?', 'O dispositivo sera reiniciado.', () {}),
                    ),
                    _settingButton(
                      'Formatar SPIFFS',
                      'Apagar todos os dados salvos no ESP32',
                      Icons.delete_forever,
                      Colors.red,
                      () => _showConfirm('Formatar SPIFFS?', 'Todos os dados serao perdidos!', () {}),
                    ),
                    _settingButton(
                      'Atualizar Firmware',
                      'Verificar e instalar atualizacoes OTA',
                      Icons.system_update,
                      const Color(0xFF00b09b),
                      () {},
                    ),

                    _sectionTitle('SOBRE'),
                    _infoCard('Versao', '3.0.0'),
                    _infoCard('Build', '2026-07-09'),
                    _infoCard('Autor', 'CrazyCat Team'),
                    _infoCard('ESP32', 'WiFi + BLE + CC1101 + NRF24'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFfa709a),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _settingSwitch(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFfa709a), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFfa709a),
          ),
        ],
      ),
    );
  }

  Widget _settingDropdown(String title, String subtitle, IconData icon, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFfa709a), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          DropdownButton<String>(
            value: value,
            dropdownColor: const Color(0xFF1a1a2e),
            style: const TextStyle(color: Colors.white),
            underline: const SizedBox(),
            items: items.map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            )).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _settingButton(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showConfirm(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('CONFIRMAR'),
          ),
        ],
      ),
    );
  }
}


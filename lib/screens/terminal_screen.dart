// ==========================================
// terminal_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final TextEditingController _commandController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _history = [
    {'type': 'system', 'text': 'CrazyCat Terminal v3.0'},
    {'type': 'system', 'text': 'Conectado ao ESP32 via Serial (115200 baud)'},
    {'type': 'system', 'text': 'Digite "help" para lista de comandos'},
    {'type': 'prompt', 'text': ''},
  ];

  final List<String> _commandHistory = [];
  int _historyIndex = -1;

  void _sendCommand() {
    final command = _commandController.text.trim();
    if (command.isEmpty) return;

    setState(() {
      _history.add({'type': 'input', 'text': 'crazycat> $command'});
      _commandHistory.add(command);
      _historyIndex = _commandHistory.length;
    });

    _processCommand(command);
    _commandController.clear();
    _scrollToBottom();
  }

  void _processCommand(String command) {
    String response;
    switch (command.toLowerCase()) {
      case 'help':
        response = '''Comandos disponiveis:
  help          - Mostra esta ajuda
  status        - Status do ESP32
  scan wifi     - Escanear redes WiFi
  scan rf       - Escanear frequencias RF
  jammer on     - Ativar jammer
  jammer off    - Desativar jammer
  deauth <mac>  - Enviar deauth
  capture       - Capturar handshake
  replay <id>   - Reproduzir sinal
  save          - Salvar sinais em SPIFFS
  load          - Carregar sinais
  clear         - Limpar terminal
  reboot        - Reiniciar ESP32
  info          - Informacoes do sistema''';
        break;
      case 'status':
        response = '''[STATUS]
CPU: 240MHz | Temp: 42C
RAM: 156KB livre / 320KB total
WiFi: AP ativo (CrazyCat) | 2 clientes
BT: Pareado | Serial: 115200
CC1101: OK | NRF24: OK
SPIFFS: 1.2MB usado / 1.5MB total''';
        break;
      case 'scan wifi':
        response = '[OK] Iniciando scan WiFi... Aguarde 5s';
        break;
      case 'scan rf':
        response = '[OK] Scanning 300-928MHz...';
        break;
      case 'jammer on':
        response = '[ALERTA] Jammer ativado! Frequencia: 433.92MHz';
        break;
      case 'jammer off':
        response = '[OK] Jammer desativado';
        break;
      case 'capture':
        response = '[OK] Iniciando captura de handshake...';
        break;
      case 'save':
        response = '[OK] Sinais salvos em /sinais.json';
        break;
      case 'load':
        response = '[OK] 12 sinais carregados da SPIFFS';
        break;
      case 'clear':
        setState(() {
          _history.clear();
          _history.add({'type': 'system', 'text': 'Terminal limpo'});
        });
        return;
      case 'reboot':
        response = '[OK] Reiniciando ESP32...';
        break;
      case 'info':
        response = '''CrazyCat v3.0.0
Build: 20260709
SDK: ESP-IDF v5.1
Board: ESP32-WROOM-32
Flash: 4MB
Autor: RF Hacking Community''';
        break;
      default:
        if (command.startsWith('deauth ')) {
          response = '[OK] Deauth enviado para ${command.substring(7)}';
        } else if (command.startsWith('replay ')) {
          response = '[OK] Reproduzindo sinal ID ${command.substring(7)}';
        } else {
          response = '[ERRO] Comando desconhecido: "$command"\nDigite "help" para ajuda';
        }
    }

    setState(() {
      _history.add({'type': 'output', 'text': response});
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_historyIndex > 0) {
          setState(() => _historyIndex--);
          _commandController.text = _commandHistory[_historyIndex];
          _commandController.selection = TextSelection.collapsed(
            offset: _commandController.text.length,
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_historyIndex < _commandHistory.length - 1) {
          setState(() => _historyIndex++);
          _commandController.text = _commandHistory[_historyIndex];
        } else {
          setState(() => _historyIndex = _commandHistory.length);
          _commandController.clear();
        }
      }
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
                    const Icon(Icons.terminal, color: Color(0xFF43e97b), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'TERMINAL',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43e97b).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF43e97b)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: Color(0xFF43e97b), size: 8),
                          SizedBox(width: 6),
                          Text(
                            'ONLINE',
                            style: TextStyle(
                              color: Color(0xFF43e97b),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Terminal Output
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF43e97b)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF43e97b).withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      return _buildTerminalLine(item);
                    },
                  ),
                ),
              ),

              // Input
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a1a2e),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF43e97b).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text(
                      'crazycat>',
                      style: TextStyle(
                        color: Color(0xFF43e97b),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: KeyboardListener(
                        focusNode: _focusNode,
                        onKeyEvent: _handleKeyEvent,
                        child: TextField(
                          controller: _commandController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Digite um comando...',
                            hintStyle: TextStyle(color: Colors.white24),
                          ),
                          onSubmitted: (_) => _sendCommand(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendCommand,
                      icon: const Icon(Icons.send, color: Color(0xFF43e97b)),
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

  Widget _buildTerminalLine(Map<String, dynamic> item) {
    final type = item['type'] as String;
    final text = item['text'] as String;

    Color color;
    switch (type) {
      case 'system':
        color = const Color(0xFF667eea);
        break;
      case 'input':
        color = const Color(0xFF43e97b);
        break;
      case 'output':
        color = Colors.white;
        break;
      case 'error':
        color = Colors.red;
        break;
      default:
        color = Colors.white70;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontFamily: 'monospace',
          height: 1.4,
        ),
      ),
    );
  }
}

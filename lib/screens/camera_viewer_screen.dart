// ==========================================
// camera_viewer_screen.dart - MJPEG STREAM
// ==========================================
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/camera_device.dart';

class CameraViewerScreen extends StatefulWidget {
  final CameraDevice camera;

  const CameraViewerScreen({super.key, required this.camera});

  @override
  State<CameraViewerScreen> createState() => _CameraViewerScreenState();
}

class _CameraViewerScreenState extends State<CameraViewerScreen> {
  Uint8List? _currentFrame;
  bool _isStreaming = false;
  bool _isLoading = true;
  String _error = '';
  StreamSubscription? _streamSubscription;
  http.Client? _httpClient;

  // Controles PTZ
  double _pan = 0.0;
  double _tilt = 0.0;
  double _zoom = 1.0;

  @override
  void initState() {
    super.initState();
    _startMjpegStream();
  }

  @override
  void dispose() {
    _stopStream();
    super.dispose();
  }

  void _startMjpegStream() {
    if (_isStreaming) return;
    _isStreaming = true;
    _httpClient = http.Client();
    _fetchMjpegFrames();
  }

  void _stopStream() {
    _isStreaming = false;
    _streamSubscription?.cancel();
    _httpClient?.close();
    _httpClient = null;
  }

  Future<void> _fetchMjpegFrames() async {
    final streamUrl = widget.camera.fullStreamUrl;

    try {
      final request = http.Request('GET', Uri.parse(streamUrl));
      request.headers['Connection'] = 'keep-alive';
      request.headers['Accept'] = 'multipart/x-mixed-replace';

      final response = await _httpClient!.send(request);

      if (response.statusCode != 200) {
        setState(() {
          _error = 'Erro HTTP ${response.statusCode}';
          _isLoading = false;
        });
        return;
      }

      final contentType = response.headers['content-type'] ?? '';
      String? boundary;

      if (contentType.contains('boundary=')) {
        boundary = contentType.split('boundary=')[1].trim();
      }

      final stream = response.stream;
      final buffer = BytesBuilder();
      bool foundFirstFrame = false;

      await for (final chunk in stream) {
        if (!_isStreaming) break;
        buffer.add(chunk);

        final data = buffer.toBytes();

        // Procura por JPEG markers (0xFF 0xD8 = start, 0xFF 0xD9 = end)
        int frameStart = -1;
        int frameEnd = -1;

        for (int i = 0; i < data.length - 1; i++) {
          if (data[i] == 0xFF && data[i + 1] == 0xD8) {
            frameStart = i;
          }
          if (data[i] == 0xFF && data[i + 1] == 0xD9 && frameStart != -1) {
            frameEnd = i + 2;
            break;
          }
        }

        if (frameStart != -1 && frameEnd != -1 && frameEnd > frameStart) {
          final frame = Uint8List.sublistView(data, frameStart, frameEnd);

          if (mounted) {
            setState(() {
              _currentFrame = frame;
              _isLoading = false;
              _error = '';
            });
          }

          // Limpa buffer e mantém dados restantes
          buffer.clear();
          if (frameEnd < data.length) {
            buffer.add(Uint8List.sublistView(data, frameEnd));
          }

          if (!foundFirstFrame) {
            foundFirstFrame = true;
          }
        }

        // Evita buffer muito grande
        if (data.length > 5 * 1024 * 1024) {
          // 5MB max
          buffer.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erro: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _sendPTZCommand(String direction) {
    // Implementar comandos PTZ via HTTP para a camera
    final ptzUrl =
        'http://${widget.camera.ip}:${widget.camera.port}/cgi-bin/ptz.cgi?action=${direction}';
    // Enviar requisição PTZ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('PTZ: $direction'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFFf093fb),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Video Feed
          _buildVideoFeed(),

          // Overlay Controls
          _buildOverlay(),

          // PTZ Controls
          _buildPTZControls(),
        ],
      ),
    );
  }

  Widget _buildVideoFeed() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFf093fb)),
            SizedBox(height: 16),
            Text(
              'Conectando ao stream MJPEG...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              _error,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _error = '';
                  _isLoading = true;
                });
                _startMjpegStream();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFf093fb),
              ),
              child: const Text('TENTAR NOVAMENTE'),
            ),
          ],
        ),
      );
    }

    if (_currentFrame != null) {
      return InteractiveViewer(
        minScale: 1.0,
        maxScale: 5.0,
        child: Image.memory(
          _currentFrame!,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        ),
      );
    }

    return const Center(
      child: Text(
        'Aguardando frames...',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: Column(
        children: [
          // Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.camera.brand} ${widget.camera.model}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${widget.camera.ip}:${widget.camera.port}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isStreaming
                        ? Colors.green.withOpacity(0.3)
                        : Colors.red.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isStreaming ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _isStreaming ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isStreaming ? 'LIVE' : 'OFF',
                        style: TextStyle(
                          color: _isStreaming ? Colors.green : Colors.red,
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

          const Spacer(),

          // Bottom Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoChip('RES', '640x480'),
                _infoChip('FPS', '~15'),
                _infoChip('PROTO', 'MJPEG'),
                _infoChip('LATENCY', '~200ms'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPTZControls() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Up
            _ptzButton(Icons.arrow_drop_up, () => _sendPTZCommand('up')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Left
                _ptzButton(Icons.arrow_left, () => _sendPTZCommand('left')),
                const SizedBox(width: 40),
                // Right
                _ptzButton(Icons.arrow_right, () => _sendPTZCommand('right')),
              ],
            ),
            // Down
            _ptzButton(Icons.arrow_drop_down, () => _sendPTZCommand('down')),
            const Divider(color: Colors.white24, height: 20),
            // Zoom In
            _ptzButton(Icons.zoom_in, () => _sendPTZCommand('zoom_in')),
            // Zoom Out
            _ptzButton(Icons.zoom_out, () => _sendPTZCommand('zoom_out')),
          ],
        ),
      ),
    );
  }

  Widget _ptzButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

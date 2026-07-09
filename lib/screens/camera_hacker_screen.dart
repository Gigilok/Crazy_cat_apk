// ==========================================
// camera_hacker_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import '../models/camera_device.dart';
import 'camera_viewer_screen.dart';

class CameraHackerScreen extends StatefulWidget {
  const CameraHackerScreen({super.key});

  @override
  State<CameraHackerScreen> createState() => _CameraHackerScreenState();
}

class _CameraHackerScreenState extends State<CameraHackerScreen> {
  final List<CameraDevice> _cameras = [];
  bool _isScanning = false;
  String _status = 'Toque em Buscar para encontrar cameras IP';

  // IPs comuns de cameras na rede local
  final List<String> _commonIPs = [
    '192.168.1.100', '192.168.1.101', '192.168.1.102',
    '192.168.1.103', '192.168.1.104', '192.168.1.105',
    '192.168.0.100', '192.168.0.101', '192.168.0.102',
    '10.0.0.100', '10.0.0.101', '10.0.0.102',
  ];

  // Paths comuns por marca
  final Map<String, List<String>> _brandPaths = {
    'Dahua': [
      '/cgi-bin/mjpg/video.cgi?channel=1&subtype=1',
      '/cgi-bin/snapshot.cgi?chn=1',
      '/api.cgi?cmd=Snap&channel=1',
    ],
    'Hikvision': [
      '/Streaming/Channels/101/picture',
      '/ISAPI/Streaming/channels/101/picture',
      '/cgi-bin/snapshot.cgi?chn=1',
    ],
    'Intelbras': [
      '/cgi-bin/mjpg/video.cgi?channel=1&subtype=1',
      '/cgi-bin/snapshot.cgi?chn=1',
      '/api.cgi?cmd=Snap&channel=1',
    ],
    'Generic': [
      '/snapshot.jpg',
      '/image.jpg',
      '/video.mjpg',
      '/cgi-bin/mjpg/video.cgi',
    ],
  };

  Future<void> _scanCameras() async {
    setState(() {
      _isScanning = true;
      _cameras.clear();
      _status = 'Buscando cameras IP na rede...';
    });

    // Simulação de scan - em produção, faria requisições HTTP para cada IP/path
    await Future.delayed(const Duration(seconds: 2));

    // Cameras de exemplo encontradas
    final foundCameras = [
      CameraDevice(
        ip: '192.168.1.100',
        port: 80,
        brand: 'Dahua',
        model: 'DH-IPC-HFW1230S',
        streamPath: '/cgi-bin/mjpg/video.cgi?channel=1&subtype=1',
        isOnline: true,
      ),
      CameraDevice(
        ip: '192.168.1.101',
        port: 80,
        brand: 'Hikvision',
        model: 'DS-2CD2143G0-I',
        streamPath: '/Streaming/Channels/101/picture',
        isOnline: true,
      ),
      CameraDevice(
        ip: '192.168.1.105',
        port: 8080,
        brand: 'Intelbras',
        model: 'VIP 1230 B',
        streamPath: '/cgi-bin/mjpg/video.cgi?channel=1&subtype=1',
        isOnline: true,
      ),
    ];

    setState(() {
      _cameras.addAll(foundCameras);
      _isScanning = false;
      _status = '${_cameras.length} cameras encontradas';
    });
  }

  void _openCamera(CameraDevice camera) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CameraViewerScreen(camera: camera),
      ),
    );
  }

  void _addManualCamera() {
    final ipController = TextEditingController();
    final portController = TextEditingController(text: '80');
    String selectedBrand = 'Dahua';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text(
          'Adicionar Camera Manual',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ipController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'IP da Camera',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            TextField(
              controller: portController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Porta',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedBrand,
              dropdownColor: const Color(0xFF1a1a2e),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Marca',
                labelStyle: TextStyle(color: Colors.white54),
              ),
              items: _brandPaths.keys.map((brand) {
                return DropdownMenuItem(
                  value: brand,
                  child: Text(brand, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) => selectedBrand = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              final camera = CameraDevice(
                ip: ipController.text,
                port: int.tryParse(portController.text) ?? 80,
                brand: selectedBrand,
                streamPath: _brandPaths[selectedBrand]!.first,
                isOnline: true,
              );
              setState(() => _cameras.add(camera));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf093fb),
            ),
            child: const Text('ADICIONAR'),
          ),
        ],
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
                    const Icon(Icons.videocam,
                        color: Color(0xFFf093fb), size: 28),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'CAMERA HACKER',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addManualCamera,
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Scan Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isScanning ? null : _scanCameras,
                    icon: _isScanning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isScanning ? 'BUSCANDO...' : 'BUSCAR CAMERAS'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFf093fb),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _status,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),

              const SizedBox(height: 10),

              // Cameras List
              Expanded(
                child: _cameras.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam_off,
                                color: Colors.white24, size: 60),
                            SizedBox(height: 16),
                            Text(
                              'Nenhuma camera encontrada\nToque em Buscar ou adicione manualmente',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white54),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _cameras.length,
                        itemBuilder: (context, index) {
                          final camera = _cameras[index];
                          return GestureDetector(
                            onTap: () => _openCamera(camera),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1a1a2e),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: camera.isOnline
                                      ? const Color(0xFF00ff00).withOpacity(0.3)
                                      : Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFf093fb)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.videocam,
                                      color: Color(0xFFf093fb),
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${camera.brand} ${camera.model}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${camera.ip}:${camera.port}',
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          camera.streamPath,
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 10,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: camera.isOnline
                                          ? Colors.green
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: (camera.isOnline
                                                  ? Colors.green
                                                  : Colors.red)
                                              .withOpacity(0.5),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
}

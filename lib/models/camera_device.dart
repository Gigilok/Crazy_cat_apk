class CameraDevice {
  final String ip;
  final int port;
  final String brand;
  final String model;
  final String streamPath;
  final bool isOnline;

  CameraDevice({
    required this.ip,
    this.port = 80,
    required this.brand,
    this.model = 'Unknown',
    required this.streamPath,
    this.isOnline = false,
  });

  String get fullStreamUrl => 'http://$ip:$port$streamPath';
}

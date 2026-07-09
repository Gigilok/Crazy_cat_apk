class BLEDevice {
  final String name;
  final String address;
  final int rssi;
  final bool isConnected;

  BLEDevice({
    required this.name,
    required this.address,
    required this.rssi,
    this.isConnected = false,
  });
}

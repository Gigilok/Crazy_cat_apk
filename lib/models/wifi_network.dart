class WiFiNetwork {
  final int id;
  final String ssid;
  final int rssi;
  final int channel;
  final bool isSecure;
  final String bssid;

  WiFiNetwork({
    required this.id,
    required this.ssid,
    required this.rssi,
    required this.channel,
    required this.isSecure,
    required this.bssid,
  });

  factory WiFiNetwork.fromJson(Map<String, dynamic> json) {
    return WiFiNetwork(
      id: json['id'] ?? 0,
      ssid: json['ssid'] ?? 'Unknown',
      rssi: json['rssi'] ?? -100,
      channel: json['canal'] ?? 0,
      isSecure: json['segura'] ?? true,
      bssid: json['bssid'] ?? '00:00:00:00:00:00',
    );
  }
}

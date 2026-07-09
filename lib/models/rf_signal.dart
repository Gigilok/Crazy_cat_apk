class RFSignal {
  final String name;
  final int frequency;
  final String modulation;
  final int rssi;
  final String protocol;
  final List<int> rawData;

  RFSignal({
    required this.name,
    required this.frequency,
    required this.modulation,
    required this.rssi,
    required this.protocol,
    required this.rawData,
  });
}

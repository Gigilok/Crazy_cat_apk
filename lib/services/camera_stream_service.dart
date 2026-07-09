// ==========================================
// camera_stream_service.dart
// ==========================================
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class CameraStreamService {
  final String baseUrl;
  StreamController<Uint8List>? _frameController;
  bool _isStreaming = false;
  http.Client? _client;

  CameraStreamService({required this.baseUrl});

  bool get isStreaming => _isStreaming;
  Stream<Uint8List>? get frameStream => _frameController?.stream;

  void startStream() {
    if (_isStreaming) return;
    _isStreaming = true;
    _frameController = StreamController<Uint8List>.broadcast();
    _client = http.Client();
    _fetchMjpegStream();
  }

  void stopStream() {
    _isStreaming = false;
    _client?.close();
    _client = null;
    _frameController?.close();
    _frameController = null;
  }

  Future<void> _fetchMjpegStream() async {
    try {
      final request = http.Request('GET', Uri.parse('$baseUrl/cgi-bin/mjpg/video.cgi?channel=1&subtype=1'));
      request.headers['Connection'] = 'keep-alive';
      
      final response = await _client!.send(request);
      if (response.statusCode != 200) {
        _isStreaming = false;
        return;
      }

      final stream = response.stream;
      final buffer = BytesBuilder();
      bool foundJpeg = false;

      await for (final chunk in stream) {
        if (!_isStreaming) break;
        buffer.add(chunk);

        final data = buffer.toBytes();
        final startIndex = _findBytes(data, [0xFF, 0xD8]); // JPEG start
        final endIndex = _findBytes(data, [0xFF, 0xD9]);     // JPEG end

        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final frame = Uint8List.sublistView(data, startIndex, endIndex + 2);
          if (!_frameController!.isClosed) {
            _frameController!.add(frame);
          }
          buffer.clear();
          if (endIndex + 2 < data.length) {
            buffer.add(Uint8List.sublistView(data, endIndex + 2));
          }
        }
      }
    } catch (e) {
      _isStreaming = false;
    }
  }

  int _findBytes(Uint8List data, List<int> pattern) {
    for (int i = 0; i <= data.length - pattern.length; i++) {
      bool match = true;
      for (int j = 0; j < pattern.length; j++) {
        if (data[i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  String getStreamUrl(String ip, {int port = 80, String path = '/cgi-bin/mjpg/video.cgi?channel=1&subtype=1'}) {
    return 'http://$ip:$port$path';
  }

  String getDahuaStreamUrl(String ip, {int port = 80}) {
    return 'http://$ip:$port/cgi-bin/mjpg/video.cgi?channel=1&subtype=1';
  }

  String getHikvisionStreamUrl(String ip, {int port = 80}) {
    return 'http://$ip:$port/Streaming/Channels/101/picture';
  }

  String getIntelbrasStreamUrl(String ip, {int port = 80}) {
    return 'http://$ip:$port/cgi-bin/mjpg/video.cgi?channel=1&subtype=1';
  }

  void dispose() {
    stopStream();
  }
}

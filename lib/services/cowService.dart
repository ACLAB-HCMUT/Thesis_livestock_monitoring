import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class CowService {
  final WebSocketChannel _channel =
      IOWebSocketChannel.connect('ws://192.168.0.102:3000');
  // Stream of Cow updates  
  Stream<Map<String, dynamic>> get cowUpdates => _channel.stream.map((data) {
    final jsonData = jsonDecode(data);
    print("Received cow update data: $jsonData");
    return jsonData; // Return the raw JSON data
  });
  void dispose() {
    _channel.sink.close();
  }
}
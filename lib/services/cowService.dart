import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:do_an_app/models/cow_model.dart';
class CowService {
  final WebSocketChannel _channel =
      IOWebSocketChannel.connect('ws://10.229.231.192:3000');
  
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

//// no longer used, MQTT instead
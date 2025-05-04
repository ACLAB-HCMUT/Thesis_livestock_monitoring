import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CowService {
  final String _url = 'ws://10.229.63.137:3000';
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>();
  Timer? _reconnectTimer;
  bool _manuallyClosed = false;

  CowService() {
    _connect();
  }

  Stream<Map<String, dynamic>> get cowUpdates => _controller.stream;

  void _connect() {
    _channel = IOWebSocketChannel.connect(_url);

    _channel!.stream.listen(
      (data) {
        final jsonData = jsonDecode(data);
        // print("Received cow update data: $jsonData");
        _controller.add(jsonData);
      },
      onError: (error) {
        // print("WebSocket error: $error");
        _scheduleReconnect();
      },
      onDone: () {
        if (!_manuallyClosed) {
          // print("WebSocket closed. Trying to reconnect...");
          _scheduleReconnect();
        }
      },
      cancelOnError: true,
    );
  }

  void _scheduleReconnect([int delaySeconds = 3]) {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      // print("Reconnecting to WebSocket...");
      _connect();
    });
  }

  void dispose() {
    _manuallyClosed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _controller.close();
  }
}

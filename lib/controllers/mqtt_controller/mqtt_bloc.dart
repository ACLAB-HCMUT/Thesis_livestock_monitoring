// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:do_an_app/controllers/cow_controller/cow_bloc.dart';
import 'package:do_an_app/controllers/cow_controller/cow_event.dart';
import 'package:do_an_app/controllers/cow_controller/cow_state.dart';
import 'package:do_an_app/global.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const HEADER_GATEWAY_SEND_GPS = 6;
const HEADER_GATEWAY_SEND_COW_STATUS = 7;

class MQTTClientHelper {
  CowBloc? _cowBloc;
  final client = MqttServerClient('mqtt.ohstem.vn', '1883');

  final String MQTT_BROKER_NAME = "nguyentruongthan";
  String password = "";
  /* Constructor */
  MQTTClientHelper() {
    print("start mqtt class");
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('dart_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .authenticateAs(MQTT_BROKER_NAME, password);

    client.connectionMessage = connMess;
  }
  void initialize(CowBloc cowBLoc) {
    _cowBloc = cowBLoc;
    connect();
  }

  /* Connect function */
  Future<void> connect() async {
    print("Connecting");
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('connect success');
    //on message
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      onMessage(c[0].topic, pt);
    });
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
  }

  /// The successful connect callback
  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');
    client.subscribe("$MQTT_BROKER_NAME/feeds/$username", MqttQos.atMostOnce);
  }

  void pong() {
    print('Ping response client callback invoked');
  }

  void onMessage(String topic, String message) {
    topic = topic.split('/')[2];
    if (topic == "V1" || topic == "V2") {
      return;
    }
    print('Received message: topic is $topic, payload is $message');
    handle_mqtt_msg(topic, message);
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(
        'nguyentruongthan/feeds/$topic', MqttQos.exactlyOnce, builder.payload!);
  }

  void handle_mqtt_msg(String topic, String message) {
    String data, cow_id;
    List<String> split_data;
    String username, response_msg;
    int header = int.parse(message.substring(0, 2));
    switch (header) {
      case HEADER_GATEWAY_SEND_GPS:
        print("HEADER_GATEWAY_SEND_GPS");
        data = message.substring(2);
        split_data = data.split(':');
        cow_id = split_data[0];
        double longitude = double.parse(split_data[1]);
        double latitude = double.parse(split_data[2]);
        _cowBloc?.add(UpdatedCowLocationMQTTEvent(cow_id, latitude, longitude));
        break;
      case HEADER_GATEWAY_SEND_COW_STATUS:
        print("HEADER_GATEWAY_SEND_COW_STATUS");
        data = message.substring(2);
        split_data = data.split(':');
        cow_id = split_data[0];
        String cow_stautus = split_data[1];
        _cowBloc?.add(UpdatedCowSatusMQTTEvent(cow_id, cow_stautus));
    }
  }
}

MQTTClientHelper mqttClientHelper = MQTTClientHelper();
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  MqttServerClient? client;

  Future<void> initializeMQTTClient(String topics) async {
    // 创建 MQTT 客户端并使用 WebSocket 连接
    client = MqttServerClient.withPort(
      'ws://192.168.204.189:8083/mqtt', // WebSocket 地址
      'flutter_client', // 客户端ID
      8083, // WebSocket 端口
    );
    client!.useWebSocket = true; // 使用 WebSocket 连接
    client!.keepAlivePeriod = 60; // 保持连接时间

    // 设置连接消息，包括用户名和密码
    final connMessage = MqttConnectMessage()
        .authenticateAs('david_mqtt', '668877') // 用户名和密码
        .withWillTopic('yp-3100-alarm') // 设置遗嘱消息主题
        .withWillMessage('Will message') // 遗嘱消息
        .startClean() // 清理会话
        .withWillQos(MqttQos.atLeastOnce); // 设置 QoS
    client!.connectionMessage = connMessage;

    try {
      // 连接到 MQTT 服务器
      print('Connecting...');
      await client!.connect();
    } catch (e) {
      print('Connection failed: $e');
      client!.disconnect();
      return;
    }

    // 检查是否连接成功
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected');
    } else {
      print('Connection failed - status: ${client!.connectionStatus}');
      client!.disconnect();
      return;
    }

    // 订阅主题
    client!.subscribe(topics, MqttQos.atLeastOnce);

    // 监听消息更新
    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      // 消息是JSON格式的 并且带有中文 如何解析并且返回出去呢
      print('Received message: $payload from topic: ${c[0].topic}');
    });
  }

  void disconnect() {
    client?.disconnect();
    print('Disconnected');
  }
}

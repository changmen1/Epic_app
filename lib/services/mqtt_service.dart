import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'notification_service.dart';

class MQTTService {
  MqttServerClient? client;

  // 定义所有需要订阅的报警主题
  final List<String> alarmTopics = [
    'MPX0-alarm',
    'DAVID_YP-90-alarm',
  ];


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
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        print('MQTT连接成功');
        // 连接成功后订阅所有报警主题
        _subscribeToTopics();

        // 设置消息监听
        client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
          if (c != null && c.isNotEmpty) {
            _handleMessage(c[0]);
          }
        });
      } else {
        print('MQTT连接失败 - 状态: ${client!.connectionStatus}');
        client!.disconnect();
      }
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

  // 订阅所有报警主题
  void _subscribeToTopics() {
    for (var topic in alarmTopics) {
      client!.subscribe(topic, MqttQos.atLeastOnce);
      print('已订阅主题: $topic');
    }
  }

  // 处理接收到的消息
  void _handleMessage(MqttReceivedMessage<MqttMessage?> message) async {
    final MqttPublishMessage pubMessage = message.payload as MqttPublishMessage;
    final String topic = message.topic;
    final String payload = MqttPublishPayload.bytesToStringAsString(pubMessage.payload.message);

    print('收到来自主题 $topic 的消息: $payload');

    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      print('解析后的数据: $data');

      // 根据不同主题处理不同类型的报警
      if (topic.endsWith('-alarm')) { // 确认是报警主题
        String alarmTitle = '设备报警';
        String alarmBody = '发生报警';

        // MPX0 监护仪报警处理
        if (topic == 'MPX0-alarm') {
          alarmTitle = '监护仪报警';
          alarmBody = '${data['patientName'] ?? '患者'}: ${data['content'] ?? '监护仪报警'}';
        }
        // YP-90 呼吸机报警处理
        else if (topic == 'DAVID_YP-90-alarm') {
          alarmTitle = '呼吸机报警';
          alarmBody = '${data['patientName'] ?? '患者'}: ${data['content'] ?? '呼吸机报警'}';
        }
        // 发送通知
        try {
          await NotificationService().showAlarmNotification(
            title: alarmTitle,
            body: alarmBody,
            payload: payload,
          );
          print('通知发送成功: $alarmTitle - $alarmBody');
        } catch (notificationError) {
          print('发送通知失败: $notificationError');
        }
      }
    } catch (e) {
      print('消息处理错误: $e');
    }
  }
}
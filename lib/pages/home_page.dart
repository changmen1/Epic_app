import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../model/patient.dart';
import '../services/mqtt_service.dart';
import '../services/patient_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<dynamic> _futureData;
  late MQTTService mqttService;
  Map<String, Map<String, dynamic>> deviceData = {}; // 保存设备实时数据

  @override
  void initState() {
    super.initState();
    _fetchData();
    _initializeMQTT(); // 初始化 MQTT
  }
  /// 获取数据的方法
  void _fetchData() {
    _futureData = PatientService().getAllCompanies();
  }
  /// 初始化 MQTT
  void _initializeMQTT() {
    mqttService = MQTTService();
    mqttService.initializeMQTTClient("topic_Philip_MPX0").then((_) {
      mqttService.client!.updates!.listen(_handleMQTTMessage); // 监听 MQTT 消息
    }).catchError((e) {
      debugPrint("MQTT 初始化失败: $e");
    });
  }
  /// 处理 MQTT 消息
  void _handleMQTTMessage(List<MqttReceivedMessage<MqttMessage?>> messages) {
    final MqttReceivedMessage<MqttMessage?> message = messages[0];
    final MqttPublishMessage mqttPublishMessage =
    message.payload as MqttPublishMessage;

    final String payloadString = MqttPublishPayload.bytesToStringAsString(
        mqttPublishMessage.payload.message);
    final Map<String, dynamic> payload = jsonDecode(payloadString);

    // 更新设备数据
    setState(() {
      deviceData[payload["devCode"]] = payload;
    });
  }

  @override
  void dispose() {
    mqttService.disconnect(); // 断开 MQTT 连接
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator( //RefreshIndicator下拉刷新功能
        onRefresh: () async {
          setState(() {
            _fetchData(); // 重新获取数据
          });
        },
        child: FutureBuilder(
            future: PatientService().getAllCompanies(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("网络请求错误,请联系管理员"),
                );
              }
              if (snapshot.hasData) {
                List<Patient> data = snapshot.data as List<Patient>;
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final patient = data[index].patientBindOutputVO;
                      final patientDevices = patient ?? [];
                      final matchingDevices = deviceData.entries
                          .where((entry) =>
                          patientDevices.contains(entry.key)) // 匹配 devCode
                          .map((entry) => entry.value)
                          .toList();
                      return Material(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: const BoxDecoration(),
                              width: double.maxFinite,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 1),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // elevation: 10, //阴影
                                  margin: const EdgeInsets.all(1),
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0x00000000) // 深灰色 FF2E2E2E
                                      : const Color(0xFFF5F5F5), // 浅灰色
                                  child: InkWell(
                                    onTap: (){
                                      print("Card点击事件");
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "${data[index].myBedNumber}床",
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                                const TextSpan(
                                                  text: '    ', // 间隔
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                TextSpan(
                                                  text: data[index].myPatientName!,
                                                  style: const TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          thickness: 0.1, // 调整粗细
                                          height: 1,     // 设置上下间距
                                          // color: Colors.blue, // 修改分割线颜色
                                        ),
                                        ListTile(
                                          title: Text(matchingDevices.isNotEmpty
                                              ? "监护仪: ${matchingDevices.map((device) => "HR:${device['mpHR']}, SpO2:${device['mpSpO2']}").join(", ")}"
                                              : "监护仪未联网"),
                                          textColor: Colors.blue,
                                        ),
                                        const ListTile(
                                          title: Text("呼吸机未联网"),
                                          textColor: Colors.blue,
                                        ),
                                        const ListTile(
                                          title: Text("培养箱未联网"),
                                          textColor: Colors.blue,
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      )
    );
  }
}




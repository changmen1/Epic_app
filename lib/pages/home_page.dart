import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../components/patient_detail.dart';
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.blue.withOpacity(0.1),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _fetchData();
            });
          },
          child: FutureBuilder(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildErrorWidget();
              }
              if (snapshot.hasData) {
                List<Patient> data = snapshot.data as List<Patient>;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, index) => _buildPatientCard(data[index]),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text("网络请求错误,请联系管理员",
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPatientCard(Patient patient) {
    final patientDevices = patient.patientBindOutputVO ?? [];
    final matchingDevices = deviceData.entries
        .where((entry) => patientDevices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shadowColor: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // 处理卡片点击事件
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailPage(patient: patient),
            ),
          );
        },
        child: Column(
          children: [
            _buildPatientHeader(patient),
            const Divider(height: 1),
            _buildDeviceStatus(matchingDevices),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(Patient patient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Text(
              patient.myBedNumber.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.myPatientName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '床号: ${patient.myBedNumber}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatus(List<Map<String, dynamic>> matchingDevices) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildDeviceStatusItem(
            icon: Icons.monitor_heart,
            title: '监护仪',
            isConnected: matchingDevices.isNotEmpty,
            details: matchingDevices.isNotEmpty
                ? _buildVitalSigns(matchingDevices.first)
                : null,
          ),
          _buildDeviceStatusItem(
            icon: Icons.air,
            title: '呼吸机',
            isConnected: false,
          ),
          _buildDeviceStatusItem(
            icon: Icons.baby_changing_station,
            title: '培养箱',
            isConnected: false,
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusItem({
    required IconData icon,
    required String title,
    required bool isConnected,
    Widget? details,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon,
            color: isConnected ? Colors.green : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (details != null) details,
                if (details == null)
                  Text(
                    isConnected ? '已连接' : '未连接',
                    style: TextStyle(
                      color: isConnected ? Colors.green : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSigns(Map<String, dynamic> device) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          _buildVitalSignItem('HR', '${device['mpHR']}', 'bpm'),
          const SizedBox(width: 16),
          _buildVitalSignItem('SpO₂', '${device['mpSpO2']}', '%'),
        ],
      ),
    );
  }

  Widget _buildVitalSignItem(String label, String value, String unit) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
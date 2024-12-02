import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/patient.dart';
import '../services/mqtt_service.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:fl_chart/fl_chart.dart';

class PatientDetailPage extends StatefulWidget {
  final Patient patient;

  const PatientDetailPage({super.key, required this.patient});

  @override
  State<PatientDetailPage> createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  final List<FlSpot> ecgData = [];
  final List<FlSpot> plethData = [];
  final List<FlSpot> respData = [];
  late MQTTService mqttService;
  Map<String, dynamic> vitalSigns = {};
  double xValue = 0;

  @override
  void initState() {
    super.initState();
    _initializeMQTT();
  }

  void _initializeMQTT() {
    mqttService = MQTTService();
    mqttService.initializeMQTTClient("topic_Philip_MPX0_Wave").then((_) {
      // 订阅波形数据主题
      mqttService.client!.subscribe(
        'topic_Philip_MPX0_Wave',
        MqttQos.atLeastOnce,
      );
      // 订阅生命体征数据主题
      mqttService.client!.subscribe(
        'topic_Philip_MPX0',
        MqttQos.atLeastOnce,
      );

      mqttService.client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final MqttPublishMessage message = messages[0].payload as MqttPublishMessage;
        final String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        final String topic = messages[0].topic;

        if (topic == 'topic_Philip_MPX0_Wave') {
          _handleWaveData(jsonDecode(payload));
        } else if (topic == 'topic_Philip_MPX0') {
          _handleVitalSigns(jsonDecode(payload));
        }
      });
    });
  }

  void _handleWaveData(Map<String, dynamic> data) {
    if (!mounted) return;

    setState(() {
      // 处理心电图数据
      if (data['ECG_II'] != null && data['ECG_II'].isNotEmpty) {
        final List<String> values = data['ECG_II'].split(',');
        for (String value in values) {
          ecgData.add(FlSpot(xValue, double.parse(value) / 100));
          xValue += 0.1;
          if (ecgData.length > 100) ecgData.removeAt(0);
        }
      }

      // 处理血氧波形数据
      if (data['Pleth'] != null && data['Pleth'].isNotEmpty) {
        final List<String> values = data['Pleth'].split(',');
        for (String value in values) {
          plethData.add(FlSpot(xValue, double.parse(value) / 100));
          if (plethData.length > 100) plethData.removeAt(0);
        }
      }

      // 处理呼吸波形数据
      if (data['Resp'] != null && data['Resp'].isNotEmpty) {
        final List<String> values = data['Resp'].split(',');
        for (String value in values) {
          respData.add(FlSpot(xValue, double.parse(value) / 100));
          if (respData.length > 100) respData.removeAt(0);
        }
      }
    });
  }

  void _handleVitalSigns(Map<String, dynamic> data) {
    if (!mounted) return;
    setState(() {
      vitalSigns = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '${widget.patient.myBedNumber}床 - ${widget.patient.myPatientName}',
          style: const TextStyle(color: Colors.green),
        ),
      ),
      body: Row(
        children: [
          // 左侧波形区域
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildWaveChart('ECG II', ecgData, Colors.green, 200),
                _buildWaveChart('Pleth', plethData, Colors.white, 100),
                _buildWaveChart('Resp', respData, Colors.green, 100),
              ],
            ),
          ),
          // 右侧生命体征数据
          Expanded(
            flex: 1,
            child: _buildVitalSignsPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveChart(String title, List<FlSpot> data, Color color, double height) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: color,
                    barWidth: 1,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalSignsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildVitalSignTile('HR', vitalSigns['mpHR']?.toString() ?? '--'),
          _buildVitalSignTile('SpO₂', vitalSigns['mpSpO2']?.toString() ?? '--'),
          _buildVitalSignTile('RR', vitalSigns['mpRespRate']?.toString() ?? '--'),
          _buildVitalSignTile('BP',
              '${vitalSigns['mpNBPsys'] ?? '--'}/${vitalSigns['mpNBPdia'] ?? '--'}'),
          Text("${widget.patient.patientBindOutputVO}")
        ],
      ),
    );
  }

  Widget _buildVitalSignTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }
}
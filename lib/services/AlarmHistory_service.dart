import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/AlarmHistory.dart';

class AlarmHistoryService {
  String baseUrl = "http://192.168.68.101:18762/";
  /// 获取报警历史记录
  Future<List<AlarmHistory>> getAllCompanies(Map<String, dynamic> requestParams) async {
    List<AlarmHistory> allPatients = [];
    try {
      var response = await http.post(
        Uri.parse(baseUrl + 'alarm/data/page'),
        headers: {'Content-Type': 'application/json'}, // 设置请求头为 JSON 格式
        body: jsonEncode(requestParams), // 使用外部传入的参数
      );
      print("状态码 ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        var records = jsonData['data']?['records']; // 使用安全访问符
        print("报警历史记录:${records}");
        if (records != null && records is List) {
          for (var company in records) {
            AlarmHistory newCompany = AlarmHistory.fromJson(company);
            allPatients.add(newCompany);
          }
        }
        return allPatients;
      } else {
        throw Exception("错误 ${response.statusCode} and ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
      return [];
    }
  }
}



import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/patient.dart';

class PatientService {
  String baseUrl = "http://192.168.68.101:18762/";
  ///获取全部
  getAllCompanies() async {
    List<Patient> allPatients = [];
    try {
      var response = await http.get(Uri.parse(baseUrl + 'patient/list'));
      print("状态码 ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        print("请求成功 ${jsonData['data']}");
        for (var company in jsonData['data']) {
          Patient newCompany = Patient.fromJson(company);
          allPatients.add(newCompany);
        }
        return allPatients;
      } else {
        throw Exception("错误 ${response.statusCode} and ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../model/company.dart';

class CompanyService {
  String baseUrl = "https://retoolapi.dev/RQZNTr/";

  ///获取全部
  getAllCompanies() async {
    List<Company> allCompanies = [];
    try {
      var response = await http.get(Uri.parse(baseUrl + 'data'));
      if (response.statusCode == 200) {
        var data = response.body;
        var jsonData = jsonDecode(data);
        print(jsonData);
        for (var company in jsonData) {
          Company newCompany = Company.fromJson(company);
          allCompanies.add(newCompany);
        }
        return allCompanies;
      } else {
        throw Exception("错误 ${response.statusCode} and ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }

  createCompany(Company company) async {
    log("create company is caleld");
    try {
      var response =
          await http.post(Uri.parse(baseUrl + 'data'), body: company.toJson());
      log("The response is ${response.body}");
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("请求成功 ${response.body}");
      } else {
        throw Exception("错误 ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }

  updateCompanyPartially(Map<String,dynamic> updatedData , int id) async {
    try {
      var response = await http.patch(Uri.parse(baseUrl + 'data' + '/${id}'), body: updatedData);
      if (response.statusCode == 201 || response.statusCode == 200) {
      print("更新成功 ${response.body}");
    } else {
      throw Exception("错误 ${response.body}");
    }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }

  updateCompany(Company company , int id) async {
    try {
      var response = await http.put(Uri.parse(baseUrl + 'data' + '/${id}'),body: company.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("更新成功 ${response.body}");
      } else {
        throw Exception("错误 ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }

  deleteCompany(int id) async {
    try {
      var response = await http.delete(Uri.parse(baseUrl + 'data' + '/${id}'));
      if (response.statusCode == 204 || response.statusCode == 200) {
        print("删除成功 ${response.body}");
      } else {
        throw Exception("错误 ${response.body}");
      }
    } catch (e) {
      print("错误: ${e.toString()}");
    }
  }
}

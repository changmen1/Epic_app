import 'package:flutter/material.dart';
import '../model/AlarmHistory.dart';
import '../services/AlarmHistory_service.dart';

class AlarmHistoryPage extends StatefulWidget {
  const AlarmHistoryPage({super.key});

  @override
  State<AlarmHistoryPage> createState() => _AlarmHistoryPageState();
}

class _AlarmHistoryPageState extends State<AlarmHistoryPage> {
  // 创建 TextEditingController 来控制输入框
  TextEditingController _searchController = TextEditingController();

  // 定义 requestParams 作为请求的参数
  Map<String, dynamic> requestParams = {
    'pageNo': 1,
    'pageSize': 10,
    'patientName': "", // 初始为空
  };

  @override
  void dispose() {
    // 在页面销毁时释放资源
    _searchController.dispose();
    super.dispose();
  }

  // 用于更新查询条件并重新请求数据
  void _updateSearchParams() {
    setState(() {
      requestParams['patientName'] = _searchController.text; // 更新查询条件
    });
  }
  // 根据 alarmLevel 返回不同颜色的圆点
  Color _getDotColor(String? level) {
    if (level == '紧急') {
      return Colors.red;
    } else if (level == '警告') {
      return Colors.yellow;
    } else if (level == '报警') {
      return Colors.blue;
    } else {
      return Colors.grey; // 意外情况 老周不反回类型
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 搜索框
            TextField(
              controller: _searchController,
              onChanged: (value) {
                _updateSearchParams(); // 每次输入框内容变化时更新请求参数
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C3E50),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.white30,
                    width: 1.0,
                  ),
                ),
                hintText: "请输入患者姓名",
                hintStyle: const TextStyle(
                  color: Colors.white70,
                ),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.white,
                // prefixIconColor: Colors.purple.shade900,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            // FutureBuilder 处理数据请求
            Expanded(
              child: FutureBuilder<List<AlarmHistory>>(
                future: AlarmHistoryService().getAllCompanies(requestParams), // 使用更新后的 requestParams
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("网络请求错误"),
                    );
                  }
                  if (snapshot.hasData) {
                    List<AlarmHistory> data = snapshot.data!;
                    return  data.isEmpty ? const Center(
                      child: Text(
                        "没有当前患者的数据",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ) :
                      ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(
                          "${data[index].patientName} ${data[index].content}" ?? "--",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          data[index].createdTime ?? "--",
                          style: const TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 小圆点
                            CircleAvatar(
                              radius: 5, // 圆点大小
                              backgroundColor: _getDotColor(data[index].level),
                            ),
                            const SizedBox(width: 8), // 圆点与文本之间的间距
                            Text(
                              data[index].level ?? "--",
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        leading: Text(
                          data[index].devName ?? "--",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

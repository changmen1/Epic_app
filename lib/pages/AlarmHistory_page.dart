import 'package:flutter/material.dart';
import '../model/AlarmHistory.dart';
import '../services/AlarmHistory_service.dart';

class AlarmHistoryPage extends StatefulWidget {
  const AlarmHistoryPage({super.key});

  @override
  State<AlarmHistoryPage> createState() => _AlarmHistoryPageState();
}

class _AlarmHistoryPageState extends State<AlarmHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  final List<AlarmHistory> _alarmList = [];

  Map<String, dynamic> requestParams = {
    'pageNo': 1,
    'pageSize': 10,
    'patientName': "",
  };

  // 根据 alarmLevel 返回不同颜色的圆点
  Color _getDotColor(String? level) {
    switch (level) {
      case '紧急':
        return Colors.red;
      case '警告':
        return Colors.yellow;
      case '报警':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool isRefresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (isRefresh) {
        requestParams['pageNo'] = 1;
        _alarmList.clear();
      }
    });

    try {
      final List<AlarmHistory> newData = await AlarmHistoryService().getAllCompanies(requestParams);
      setState(() {
        _alarmList.addAll(newData);
        _hasMore = newData.length >= requestParams['pageSize'];
        if (_hasMore) {
          requestParams['pageNo']++;
        }
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadData();
    }
  }

  void _updateSearchParams() {
    setState(() {
      requestParams['patientName'] = _searchController.text;
      requestParams['pageNo'] = 1;
      _alarmList.clear();
      _hasMore = true;
      _loadData();
    });
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchBar(),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadData(isRefresh: true),
                child: _buildAlarmList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // 根据主题设置背景色
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _updateSearchParams(),
        // 设置输入文字颜色
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintText: "搜索患者姓名",
          // 设置提示文字颜色
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            // 设置图标颜色
            color: isDarkMode ? Colors.blue[300] : Colors.blue,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              // 设置清除按钮颜色
              color: isDarkMode ? Colors.grey[400] : Colors.grey,
            ),
            onPressed: () {
              _searchController.clear();
              _updateSearchParams();
            },
          ),
          // 设置填充颜色
          fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildAlarmList() {
    if (_alarmList.isEmpty && !_isLoading) {
      return const Center(
        child: Text(
          "暂无报警记录",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _alarmList.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _alarmList.length) {
          return _buildLoadingIndicator();
        }
        return _buildAlarmCard(_alarmList[index]);
      },
    );
  }

  Widget _buildAlarmCard(AlarmHistory alarm) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shadowColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: _getDotColor(alarm.level),
                ),
                const SizedBox(width: 8),
                Text(
                  alarm.level ?? "--",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  alarm.devName ?? "--",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "${alarm.patientName} ${alarm.content}" ?? "--",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              alarm.createdTime ?? "--",
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

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}

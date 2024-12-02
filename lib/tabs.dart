import 'package:epic_david_app/pages/AlarmHistory_page.dart';
import 'package:epic_david_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'components/my_drawer.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    HomePage(),
    AlarmHistoryPage(),
  ];
  // 动态标题
  final List<String> _titles = ["患者监护", "报警历史"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //超过三个导航 需要设置这个属性
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white, // 选中的图标和文字颜色
        unselectedItemColor: Colors.grey, // 未选中的图标和文字颜色
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex=index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: "报警历史"
          )
        ],),
    );
  }
}
import 'package:epic_david_app/pages/login_page.dart';
import 'package:epic_david_app/services/notification_service.dart';
import 'package:epic_david_app/tabs.dart';
import 'package:epic_david_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init(); // 初始化通知服务
  testNotification();
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

void testNotification() {
  NotificationService().showAlarmNotification(
    title: '测试通知',
    body: '戴维医疗',
    payload: 'test',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        "/tabs": (context) => const Tabs(), // 添加其他页面的路由
      },
    );
  }
}

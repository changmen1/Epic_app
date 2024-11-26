import 'package:epic_david_app/components/my_drawer_title.dart';
import 'package:epic_david_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                // child: Icon(
                //   Icons.person,
                //   size: 72,
                //   color: Theme.of(context).colorScheme.primary,
                // ),
                child: Image.asset(
                  'images/david/davidlogo.jpeg', // 替换成你的图片路径
                  width: 100,
                  height: 135,
                  fit: BoxFit.cover,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // divider line
              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(height: 10,),
              MyDrawerTitle(
                title: '主页',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.pushReplacementNamed(context, "/tabs");
                },
              ),
              MyDrawerTitle(
                title: '设置',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                },
              ),
              MyDrawerTitle(
                title: '退出',
                icon: Icons.output,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

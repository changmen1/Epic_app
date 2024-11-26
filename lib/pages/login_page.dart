import 'package:epic_david_app/components/my_button.dart';
import 'package:epic_david_app/components/my_text_field.dart';
import 'package:epic_david_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.lock_open_rounded,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                Text(
                  "欢迎来到中央监护系统!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 50),
                MyTextField(
                  controller: emailController,
                  hintText: "请输入用户名...",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: pwController,
                  hintText: "请输入密码...",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "忘记密码",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "登   录",
                  onTap: () {
                    print(
                        ">>>>>>>>>>>>>>>>>>>>>>>>>>$emailController $pwController");
                    if (emailController.text == "admin" &&
                        pwController.text == "123456") {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const HomePage()),
                      // );
                      Navigator.pushReplacementNamed(context, "/tabs");
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("登录成功")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("账号或密码错误")));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

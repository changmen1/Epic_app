import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/user_angreement_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUserAgreement();
    });
  }

  void _showUserAgreement() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const UserAgreementDialog(),
    );

    if (result == false) {
      SystemNavigator.pop();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            // 使用 SingleChildScrollView 包裹内容
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Logo区域
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'images/david/davidlogo.jpeg',
                        width: 80,
                        height: 80,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 公司名称
                    const Text(
                      "戴维医疗",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "中央监护系统",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 50),
                    // 登录表单
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "账号登录",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: usernameController,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "用户名",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.blue.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue.shade700),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              labelText: "密码",
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.blue.shade700,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.blue.shade700),
                              ),
                              fillColor: Colors.grey.shade50,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                                  : const Text(
                                "登 录",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  letterSpacing: 4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 版权信息
                    const Spacer(),
                    Column(
                      children: [
                        const Divider(
                          color: Colors.white24,
                          indent: 80,
                          endIndent: 80,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'images/david/davidlogo.jpeg',
                              width: 20,
                              height: 20,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Version 1.0.0",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "浙江戴维医疗器械股份有限公司",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "© ${DateTime.now().year} All Rights Reserved",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorMessage("请输入用户名和密码");
      return;
    }

    setState(() => isLoading = true);

    // 模拟登录延迟
    await Future.delayed(const Duration(seconds: 1));

    if (usernameController.text == "admin" && passwordController.text == "123456") {
      Navigator.pushReplacementNamed(context, "/tabs");
      _showSuccessMessage("登录成功");
    } else {
      _showErrorMessage("用户名或密码错误");
    }

    setState(() => isLoading = false);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
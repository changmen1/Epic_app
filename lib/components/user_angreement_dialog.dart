import 'package:flutter/material.dart';

class UserAgreementDialog extends StatelessWidget {
  final Function()? onAgree;
  final Function()? onDisagree;

  const UserAgreementDialog({
    super.key,
    this.onAgree,
    this.onDisagree,
  });

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => UserAgreementDialog(
        onAgree: () => Navigator.of(context).pop(true),
        onDisagree: () => Navigator.of(context).pop(false),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 顶部标题
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Center(
                child: Text(
                  "用户服务协议和隐私政策",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 内容区域
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "感谢您使用戴维医疗中央监护系统！",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "请您在使用前仔细阅读以下协议，这将帮助您了解：",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      "1. 我们如何收集和使用您的信息",
                      "• 在您使用我们的服务时，我们会收集与您使用的功能相关的信息\n"
                          "• 我们严格遵守相关法律法规，保护您的个人信息安全\n"
                          "• 未经您的同意，我们不会向第三方分享您的个人信息",
                    ),
                    _buildSection(
                      "2. 信息安全",
                      "• 我们使用业界领先的安全技术保护您的信息\n"
                          "• 定期进行安全评估和系统升级\n"
                          "• 严格的内部访问控制机制",
                    ),
                    _buildSection(
                      "3. 用户责任",
                      "• 请妥善保管您的账号和密码\n"
                          "• 确保输入数据的准确性\n"
                          "• 遵守相关法律法规和专业规范",
                    ),
                    _buildSection(
                      "4. 技术支持",
                      "• 7×24小时技术支持服务\n"
                          "• 定期的系统维护和更新\n"
                          "• 专业的培训和指导",
                    ),
                  ],
                ),
              ),
            ),

            // 底部按钮区域
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false), // 不同意返回 false
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                      ),
                      child: const Text("不同意"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true), // 同意返回 true
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "同意并继续",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
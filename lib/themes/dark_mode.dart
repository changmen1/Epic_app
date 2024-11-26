import 'package:flutter/material.dart';

/// 定义暗黑模式的主题样式
ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    /// 表面颜色，用于背景和卡片等区域
    // surface: const Color.fromARGB(255, 20, 20, 20),
    surface: const Color(0xFF020817),
    /// 主要颜色，用于按钮、标题等主要元素
    primary: const Color.fromARGB(255, 105, 105, 105),
    /// 次要颜色，用于辅助按钮、图标等次要元素
    secondary: const Color.fromARGB(255, 30, 30, 30),
    /// 第三颜色，用于分割线、边框等次级用途
    tertiary: const Color.fromARGB(255, 47, 47, 47),
    /// 反向主要颜色，用于与暗背景对比的文本或图标
    inversePrimary: Colors.grey.shade300,
  ),
);

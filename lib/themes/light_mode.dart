import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    /// 表面颜色，用于背景和卡片等区域
    surface: Colors.grey.shade300,
    /// 主要颜色，用于按钮、标题等主要元素
    primary: Colors.grey.shade500,
    /// 次要颜色，用于辅助按钮、图标等次要元素
    secondary: Colors.grey.shade200,
    /// 第三颜色，用于分割线、边框等次级用途
    tertiary: Colors.white,
    /// 反向主要颜色，用于与暗背景对比的文本或图标
    inversePrimary: Colors.grey.shade900,
  ),
);
import 'dart:ui';

import 'package:flutter/material.dart';

class Util{
  static Color hexToColor(String hexColor) {
    // 移除可能包含的 '#' 符号
    hexColor = hexColor.replaceAll('#', '');

    // 如果16进制字符串长度不为6，则返回默认颜色
    if (hexColor.length != 6) {
      return Colors.black;
    }

    // 将16进制颜色转换为RGB值
    int red = int.parse(hexColor.substring(0, 2), radix: 16);
    int green = int.parse(hexColor.substring(2, 4), radix: 16);
    int blue = int.parse(hexColor.substring(4, 6), radix: 16);

    // 返回对应的Color对象
    return Color.fromRGBO(red, green, blue, 1.0);
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  };
}
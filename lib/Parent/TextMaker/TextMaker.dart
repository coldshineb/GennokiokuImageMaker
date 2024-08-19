import 'package:flutter/material.dart';

import '../../Util.dart';

//文本生成器大类接口
mixin class TextMaker {
  void copiedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      margin: EdgeInsets.all(10.0),
      behavior: SnackBarBehavior.floating,
      content: Text("已复制到剪贴板"),
    ));
  }

  ButtonStyle buttonStyle(BuildContext context) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
          Theme.of(context).brightness == Brightness.light
              ? Colors.pink[50]
              : Util.darkColorScheme().onSecondary),
    );
  }
}

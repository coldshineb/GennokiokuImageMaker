import 'package:flutter/material.dart';

import '../Util.dart';

class Widgets {
  static Container lineNumberIcon(
      Color lineColor, String lineNumber, String lineNumberEN) {
    Container container = Container();

    // 正则表达式
    RegExp oneDigit = RegExp(r'^\d$'); // 匹配1个数字  1 2 3 4...
    RegExp twoDigits = RegExp(r'^\d{2}$'); // 匹配2个数字  10 11 12 13...
    RegExp oneDigitOneCharacter =
        RegExp(r'^[a-zA-Z]\d$'); // 匹配1个字符1个数字  S1 S2 L1 L2 C5...
    RegExp threeChineseCharacters = RegExp(r'^[\u4e00-\u9fff]{3}$'); // 匹配3个汉字
    RegExp fourChineseCharacters =
        RegExp(r'^[\u4e00-\u9fff]{4}$'); // 匹配4个汉字 南城环线  漓水环线 环山北线...
    RegExp fiveChineseCharacters =
        RegExp(r"^[\u4e00-\u9fff]{5}$"); // 匹配5个汉字 创新港环线...

    //要达到完美显示效果，必须使用层叠组件，否则文字显示打架
    //因此需要根据不同线路名称手动调节显示效果，不可使用动态调节
    if (oneDigit.hasMatch(lineNumber)) {
      container = Container(
          width: 75,
          height: 45,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Stack(children: [
            Positioned(
              bottom: -2,
              left: 5,
              child: Text(
                lineNumber,
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: "GennokiokuLCDFont",
                    color: Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              left: 29,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 28,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (twoDigits.hasMatch(lineNumber) ||
        oneDigitOneCharacter.hasMatch(lineNumber)) {
      container = Container(
          width: 105,
          height: 45,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Stack(children: [
            Positioned(
              bottom: -2,
              left: 5,
              child: Text(
                lineNumber,
                style: TextStyle(
                    letterSpacing: -3,
                    fontSize: 40,
                    fontFamily: "GennokiokuLCDFont",
                    color: Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              left: 51,
              child: Text(
                "号线",
                style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 18,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 50,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (fourChineseCharacters.hasMatch(lineNumber)) {
      container = Container(
          width: 95,
          height: 45,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Stack(children: [
            Positioned(
              left: 7,
              child: Text(
                lineNumber,
                style: TextStyle(
                    letterSpacing: 3,
                    fontSize: 18,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 24,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (fiveChineseCharacters.hasMatch(lineNumber)) {
      container = Container(
          width: 95,
          height: 45,
          decoration: BoxDecoration(
            color: lineColor,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Stack(children: [
            Positioned(
              left: 7,
              child: Text(
                lineNumber,
                style: TextStyle(
                    letterSpacing: -1.9,
                    fontSize: 18,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 24,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    }
    return container;
  }

  static List<DropdownMenuItem> resolutionList() {
    return [
      const DropdownMenuItem(
        value: 2560,
        child: Text(
          "2560*500",
          style:
              TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: 5120,
        child: Text(
          "5120*1000",
          style:
              TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: 10240,
        child: Text(
          "10240*2000",
          style:
              TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      )
    ];
  }
}

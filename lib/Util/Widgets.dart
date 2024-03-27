import 'package:flutter/material.dart';
import 'package:main/Util/CustomRegExp.dart';

import '../Object/Line.dart';
import '../Util.dart';

class Widgets {
  //线路名称标识
  static Container lineNumberIcon(
      Color lineColor, String lineNumber, String lineNumberEN) {
    Container container = Container();

    //要达到完美显示效果，必须使用层叠组件，否则文字显示打架
    //因此需要根据不同线路名称手动调节显示效果，不可使用动态调节
    if (CustomRegExp.oneDigit.hasMatch(lineNumber)) {
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
              left: 30,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 24,
              left: 30,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (CustomRegExp.twoDigits.hasMatch(lineNumber) ||
        CustomRegExp.oneDigitOneCharacter.hasMatch(lineNumber)) {
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
              left: 4,
              child: Transform(
                  transform: Matrix4.diagonal3Values(0.7, 1.0, 1.0),
                  child: Text(
                    lineNumber,
                    style: TextStyle(
                        letterSpacing: -3,
                        fontSize: 40,
                        fontFamily: "GennokiokuLCDFont",
                        color: Util.getTextColorForBackground(lineColor)),
                  )),
            ),
            Positioned(
              left: 30,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 24,
              left: 30,
              child: Text(
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "GennokiokuLCDFont",
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (CustomRegExp.fourChineseCharacters.hasMatch(lineNumber)) {
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
    } else if (CustomRegExp.fiveChineseCharacters.hasMatch(lineNumber)) {
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

  //导出分辨率选择下拉列表
  static List<DropdownMenuItem> resolutionListLCD() {
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

  //导出分辨率选择下拉列表
  static List<DropdownMenuItem> resolutionListCover() {
    return [
      const DropdownMenuItem(
        value: 1920,
        child: Text(
          "1920*320",
          style:
          TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: 3840,
        child: Text(
          "3840*640",
          style:
          TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      ),
      const DropdownMenuItem(
        value: 7680,
        child: Text(
          "7680*1280",
          style:
          TextStyle(fontFamily: "GennokiokuLCDFont", color: Colors.black),
        ),
      )
    ];
  }

  //一系列换乘线路图标中的文字，因为后期有 U 型线路图，因此文字部分单独抽出来，没有抽出整个 Stack
  static Container transferLineIcon(Line transferLine) {
    return Container(
      height: 34,
      width: 34,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Util.hexToColor(transferLine.lineColor)),
    );
  }

  static Positioned transferLineTextOneDigit(Line transferLine) {
    return Positioned(
      top: -6,
      left: 9,
      child: Text(
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 28,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }

  static Positioned transferLineTextTwoDigits(Line transferLine) {
    return Positioned(
      top: -6,
      left: 4,
      child: Text(
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 28,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }

  static Positioned transferLineTextTwoCharacters(Line transferLine) {
    return Positioned(
      top: 2,
      left: 6,
      child: Text(
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 18,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }

  static Positioned transferLineTextOneDigitOneCharacter(
      Line transferLine) {
    return Positioned(
      top: 1,
      left: 4,
      child: Text(
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 20,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }
}

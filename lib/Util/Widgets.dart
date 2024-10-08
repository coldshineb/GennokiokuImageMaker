import 'package:flutter/material.dart';
import '/Util/CustomRegExp.dart';

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
              left: 0,
              right: 40,
              child: Text(
                textAlign: TextAlign.center,
                lineNumber,
                style: TextStyle(
                    fontSize: 40,
                    color: Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              left: 30,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 20,
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
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (CustomRegExp.twoDigits.hasMatch(lineNumber)) {
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
              left: 0,
              right: 30,
              child: Transform(
                  transform: Matrix4.diagonal3Values(0.7, 1.0, 1.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    lineNumber,
                    style: TextStyle(
                        letterSpacing: -3,
                        fontSize: 40,
                        color: Util.getTextColorForBackground(lineColor)),
                  )),
            ),
            Positioned(
              left: 30,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 20,
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
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    } else if (CustomRegExp.oneDigitOneCharacter.hasMatch(lineNumber)) {
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
              left: 0,
              right: 25,
              child: Transform(
                  transform: Matrix4.diagonal3Values(0.6, 1.0, 1.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    lineNumber,
                    style: TextStyle(
                        letterSpacing: -3,
                        fontSize: 40,
                        color: Util.getTextColorForBackground(lineColor)),
                  )),
            ),
            Positioned(
              left: 30,
              child: Text(
                "号线",
                style: TextStyle(
                    fontSize: 20,
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
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 0,
              right: 0,
              child: Text(
                textAlign: TextAlign.center,
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
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
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
            Positioned(
              top: 22,
              left: 0,
              right: 0,
              child: Text(
                textAlign: TextAlign.center,
                "Line $lineNumberEN",
                style: TextStyle(
                    fontSize: 14,
                    color: lineColor == Colors.transparent
                        ? Colors.transparent
                        : Util.getTextColorForBackground(lineColor)),
              ),
            ),
          ]));
    }
    return container;
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
      left: 0,
      right: 0,
      child: Text(
        textAlign: TextAlign.center,
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
      top: -3,
      left: 0,
      right: 0,
      child: Text(
        textAlign: TextAlign.center,
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 24,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }

  static Positioned transferLineTextTwoCharacters(Line transferLine) {
    return Positioned(
      top: 2,
      left: 0,
      right: 0,
      child: Text(
        textAlign: TextAlign.center,
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 18,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }

  static Positioned transferLineTextOneDigitOneCharacter(Line transferLine) {
    return Positioned(
      top: 1,
      left: 0,
      right: 0,
      child: Text(
        textAlign: TextAlign.center,
        transferLine.lineNumberEN,
        style: TextStyle(
            fontSize: 20,
            color: Util.getTextColorForBackground(
                Util.hexToColor(transferLine.lineColor))),
      ),
    );
  }
}

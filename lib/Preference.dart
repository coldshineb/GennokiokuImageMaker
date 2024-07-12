import 'package:flutter/material.dart';

//存储设置项的值，涉及到实际效果的在Util中
class Preference {
  static late ThemeMode themeMode;
  static late bool generalIsDevMode;
  static late bool generalIsScaleEnabled;
  static late bool generalIsWhiteBackgroundInDarkMode;
}

//存储设置项的键
class PreferenceKey {
  static const String generalThemeMode = 'general.themeMode';
  static const String generalIsScaleEnabled = 'general.isScaleEnabled';
  static const String generalIsDevMode = 'general.isDevMode';
  static const String generalIsWhiteBackgroundInDarkMode =
      'general.isWhiteBackgroundInDarkMode';
  static const String lcdMaxStation = 'lcd.maxStation';
  static const String screenDoorCoverMaxStation = 'screenDoorCover.maxStation';
  static const String lcdIsBoldFont = 'lcd.isBoldFont';
  static const String lcdIsRouteColorSameAsLineColor = 'lcd.isRouteColorSameAsLineColor';
  static const String screenDoorCoverIsBoldFont = 'screenDoorCover.isBoldFont';
}

//默认设置项的值
class DefaultPreference {
  static const bool generalIsDevMode = false;
  static const bool generalIsScaleEnabled = false;
  static const bool generalIsWhiteBackgroundInDarkMode = false;
  static const int lcdMaxStation = 35;
  static const int screenDoorCoverMaxStation = 36;
  static const bool lcdIsBoldFont = true;
  static const bool lcdIsRouteColorSameAsLineColor = true;
  static const bool screenDoorCoverIsBoldFont = true;
}

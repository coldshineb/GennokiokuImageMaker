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
  static const String railwayTransitLcdMaxStation =
      'railwayTransit.lcd.maxStation';
  static const String railwayTransitScreenDoorCoverMaxStation =
      'railwayTransit.screenDoorCover.maxStation';
  static const String railwayTransitLcdIsBoldFont =
      'railwayTransit.lcd.isBoldFont';
  static const String railwayTransitLcdIsRouteColorSameAsLineColor =
      'railwayTransit.lcd.isRouteColorSameAsLineColor';
  static const String railwayTransitScreenDoorCoverIsBoldFont =
      'railwayTransit.screenDoorCover.isBoldFont';
}

//默认设置项的值
class DefaultPreference {
  static const bool generalIsDevMode = false;
  static const bool generalIsScaleEnabled = false;
  static const bool generalIsWhiteBackgroundInDarkMode = false;
  static const int railwayTransitLcdMaxStation = 35;
  static const int railwayTransitScreenDoorCoverMaxStation = 36;
  static const bool railwayTransitLcdIsBoldFont = true;
  static const bool railwayTransitLcdIsRouteColorSameAsLineColor = true;
  static const bool railwayTransitScreenDoorCoverIsBoldFont = true;
}

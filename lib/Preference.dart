import 'package:flutter/material.dart';

class Preference {
  static late ThemeMode themeMode;
  static late bool generalIsDevMode;
  static late int lcdMaxStation;
  static late int screenDoorCoverMaxStation;
  static late bool lcdIsBoldFont;
  static late bool screenDoorCoverIsBoldFont;
}

class PreferenceKey {
  static const String generalThemeMode = 'general.themeMode';
  static const String generalIsDevMode = 'general.isDevMode';
  static const String lcdMaxStation = 'lcd.maxStation';
  static const String screenDoorCoverMaxStation = 'screenDoorCover.maxStation';
  static const String lcdIsBoldFont = 'lcd.isBoldFont';
  static const String screenDoorCoverIsBoldFont = 'screenDoorCover.isBoldFont';
}

class DefaultPreference {
  static const int generalThemeMode = 0;
  static const bool generalIsDevMode = false;
  static const int lcdMaxStation = 32;
  static const int screenDoorCoverMaxStation = 36;
  static const bool lcdIsBoldFont = true;
  static const bool screenDoorCoverIsBoldFont = true;
}

class Preference {
  static late bool generalIsDevMode;
  static late int lcdMaxStation;
  static late int screenDoorCoverMaxStation;
  static late bool lcdIsBoldFont;
  static late bool screenDoorCoverIsBoldFont;
}

class PreferenceKey {
  static const String generalIsDevMode = 'general.isDevMode';
  static const String lcdMaxStation = 'lcd.maxStation';
  static const String screenDoorCoverMaxStation = 'screenDoorCover.maxStation';
  static const String lcdIsBoldFont = 'lcd.isBoldFont';
  static const String screenDoorCoverIsBoldFont = 'screenDoorCover.isBoldFont';
}

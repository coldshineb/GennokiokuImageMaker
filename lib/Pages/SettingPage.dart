import 'package:flutter/material.dart';
import 'package:main/Preference.dart';
import 'package:main/main.dart';

import '../Parent/SettingPage.dart';
import '../Util.dart';

class GeneralSettingPageRoot extends StatelessWidget {
  const GeneralSettingPageRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: GeneralSettingPage());
  }
}

//通用设置页面
class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  GeneralSettingPageState createState() => GeneralSettingPageState();
}

class GeneralSettingPageState extends State<GeneralSettingPage>
    with SettingPage {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createHeading('通用'),
              const SizedBox(height: 10.0),
              Material(
                color: settingPageMaterialColor(context),
                borderRadius: settingPageBorderRadius(),
                child: InkWell(
                  borderRadius: settingPageBorderRadius(),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('应用主题'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('跟随系统'),
                                  onTap: () {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.generalThemeMode, 0);
                                    setState(() {
                                      Preference.themeMode = ThemeMode.system;
                                      main(); //3个main刷新主题，目前只能这样曲线救国
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('浅色'),
                                  onTap: () {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.generalThemeMode, 1);
                                    setState(() {
                                      Preference.themeMode = ThemeMode.light;
                                      main();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  title: const Text('深色'),
                                  onTap: () {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.generalThemeMode, 2);
                                    setState(() {
                                      Preference.themeMode = ThemeMode.dark;
                                      main();
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: settingPageBorderRadius(),
                      ),
                      padding: settingPageEdgeInsets(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(top: 8.0)),
                              const Text(
                                '应用主题',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(top: 8.0))
                            ],
                          )),
                          Container(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: Text(
                              Preference.themeMode == ThemeMode.system
                                  ? '跟随系统'
                                  : Preference.themeMode == ThemeMode.light
                                      ? '浅色'
                                      : '深色',
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.grey),
                            ),
                          )
                        ],
                      )),
                ),
              ),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey
                                  .generalIsWhiteBackgroundInDarkMode) ??
                          DefaultPreference.generalIsWhiteBackgroundInDarkMode;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsWhiteBackgroundInDarkMode,
                          !currentValue);
                    });
                  },
                  '深色主题下使用白色背景',
                  '',
                  HomeState.sharedPreferences?.getBool(
                          PreferenceKey.generalIsWhiteBackgroundInDarkMode) ??
                      DefaultPreference.generalIsWhiteBackgroundInDarkMode,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsWhiteBackgroundInDarkMode,
                          value);
                    });
                  }),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences
                              ?.getBool(PreferenceKey.generalIsDevMode) ??
                          DefaultPreference.generalIsDevMode;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsDevMode, !currentValue);
                    });
                  },
                  '启用开发选项',
                  '',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.generalIsDevMode,
                      ) ??
                      DefaultPreference.generalIsDevMode,
                  (value) {
                    setState(() {
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.generalIsDevMode, value);
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

//LCD显示屏设置页面
class LCDSettingPage extends StatefulWidget {
  const LCDSettingPage({super.key});

  @override
  LCDSettingPageState createState() => LCDSettingPageState();
}

class LCDSettingPageState extends State<LCDSettingPage> with SettingPage {
  //设置各项参数的中间变量，用于不要在输入时直接修改参数，而是在按下确定按钮时修改
  String maxStationToSet = HomeState.sharedPreferences
          ?.getInt(PreferenceKey.lcdMaxStation)
          ?.toString() ??
      '${DefaultPreference.lcdMaxStation}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createHeading('LCD 显示屏'),
              const SizedBox(height: 10.0),
              createChangeIntDialog(
                  context,
                  '允许的最大站点数量',
                  '限制导入的线路信息文件中站点数量，默认为 ${DefaultPreference.lcdMaxStation}。调整数量可能会导致降低美观程度，或出现显示异常',
                  '${DefaultPreference.lcdMaxStation}',
                  HomeState.sharedPreferences
                          ?.getInt(PreferenceKey.lcdMaxStation)
                          ?.toString() ??
                      '${DefaultPreference.lcdMaxStation}', (String value) {
                maxStationToSet = value;
              }, () {
                setState(() {
                  if (maxStationToSet.isEmpty) {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.lcdMaxStation,
                        DefaultPreference.lcdMaxStation);
                    Util.lcdMaxStation = DefaultPreference.lcdMaxStation;
                  } else {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.lcdMaxStation,
                        int.parse(maxStationToSet));
                    Util.lcdMaxStation = int.parse(maxStationToSet);
                  }
                });
                Navigator.of(context).pop();
              }),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences
                              ?.getBool(PreferenceKey.lcdIsBoldFont) ??
                          DefaultPreference.lcdIsBoldFont;
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.lcdIsBoldFont, !currentValue);
                      Util.lcdBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  '使用中粗体',
                  '下一站、当前站、终点站和站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.lcdIsBoldFont,
                      ) ??
                      DefaultPreference.lcdIsBoldFont,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.lcdIsBoldFont, value);
                      Util.lcdBoldFont =
                          value ? FontWeight.w600 : FontWeight.normal;
                    });
                  }),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey.lcdIsRouteColorSameAsLineColor) ??
                          DefaultPreference.lcdIsRouteColorSameAsLineColor;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.lcdIsRouteColorSameAsLineColor,
                          !currentValue);
                      Util.lcdRouteColorSameAsLineColor = !currentValue;
                    });
                  },
                  '使用线路标识色作为未过站站点图标与线路线条颜色',
                  '默认为开启。关闭后则使用绿色，在一些线路标识色与已过站、下一站站点图标等预设颜色相近时，有助于颜色区分',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.lcdIsRouteColorSameAsLineColor,
                      ) ??
                      DefaultPreference.lcdIsRouteColorSameAsLineColor,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.lcdIsRouteColorSameAsLineColor, value);
                      Util.lcdRouteColorSameAsLineColor = value;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

//屏蔽门盖板设置页面
class ScreenDoorCoverSettingPage extends StatefulWidget {
  const ScreenDoorCoverSettingPage({super.key});

  @override
  ScreenDoorCoverSettingPageState createState() =>
      ScreenDoorCoverSettingPageState();
}

class ScreenDoorCoverSettingPageState extends State<ScreenDoorCoverSettingPage>
    with SettingPage {
  String maxStationToSet = HomeState.sharedPreferences
          ?.getInt(PreferenceKey.screenDoorCoverMaxStation)
          ?.toString() ??
      "${DefaultPreference.screenDoorCoverMaxStation}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              createHeading('屏蔽门盖板'),
              const SizedBox(height: 10.0),
              createChangeIntDialog(
                  context,
                  '允许的最大站点数量',
                  '限制导入的线路信息文件中站点数量，默认为 ${DefaultPreference.screenDoorCoverMaxStation}。调整数量可能会导致降低美观程度，或出现显示异常',
                  '${DefaultPreference.screenDoorCoverMaxStation}',
                  HomeState.sharedPreferences
                          ?.getInt(PreferenceKey.screenDoorCoverMaxStation)
                          ?.toString() ??
                      "${DefaultPreference.screenDoorCoverMaxStation}",
                  (String value) {
                maxStationToSet = value;
              }, () {
                setState(() {
                  if (maxStationToSet.isEmpty) {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.screenDoorCoverMaxStation,
                        DefaultPreference.screenDoorCoverMaxStation);
                    Util.screenDoorCoverMaxStation =
                        DefaultPreference.screenDoorCoverMaxStation;
                  } else {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.screenDoorCoverMaxStation,
                        int.parse(maxStationToSet));
                    Util.screenDoorCoverMaxStation = int.parse(maxStationToSet);
                  }
                });
                Navigator.of(context).pop();
              }),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey.screenDoorCoverIsBoldFont) ??
                          DefaultPreference.screenDoorCoverIsBoldFont;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.screenDoorCoverIsBoldFont,
                          !currentValue);
                      Util.screenDoorCoverBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  '使用中粗体',
                  '站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.screenDoorCoverIsBoldFont,
                      ) ??
                      DefaultPreference.screenDoorCoverIsBoldFont,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.screenDoorCoverIsBoldFont, value);
                      Util.screenDoorCoverBoldFont =
                          value ? FontWeight.w600 : FontWeight.normal;
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../Parent/SettingPage.dart';
import '../Preference.dart';
import '../Util.dart';
import '../main.dart';

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
              createHeading('设置'),
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
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey.generalIsScaleEnabled) ??
                          DefaultPreference.generalIsScaleEnabled;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsScaleEnabled, !currentValue);
                    });
                  },
                  '启用缩放和自由滑动(实验性选项)',
                  '通过手势或鼠标滚轮缩放及自由滑动图片，最高支持放大至 ${Util.maxScale.round()} 倍，默认为关闭。开启后则禁用滚轮页面滑动，部分图片经过缩放后最小显示比例异常，不影响导出分辨率及效果',
                  HomeState.sharedPreferences?.getBool(
                          PreferenceKey.generalIsScaleEnabled) ??
                      DefaultPreference.generalIsScaleEnabled,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsScaleEnabled, value);
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
                  }),
              const SizedBox(height: 10.0),
              createHeading('其它信息'),
              const SizedBox(height: 10.0),
              Material(
                color: settingPageMaterialColor(context),
                borderRadius: settingPageBorderRadius(),
                child: InkWell(
                  borderRadius: settingPageBorderRadius(),
                  onTap: () {
                    showLicensePage(context: context);
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
                                '开源许可',
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
                            child: const Icon(Icons.arrow_forward),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

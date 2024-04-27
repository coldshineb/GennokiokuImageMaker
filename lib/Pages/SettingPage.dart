import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/Preference.dart';
import 'package:main/main.dart';

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

class GeneralSettingPageState extends State<GeneralSettingPage> {
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
              const Text(
                '通用',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('主题模式'),
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
                                    main();//3个main刷新主题，目前只能这样曲线救国
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
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        decoration: settingPageBoxDecoration(context),
                        padding: settingPageEdgeInsets(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '主题模式',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '选择应用的主题模式，默认为跟随系统',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
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
                        ))),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences
                              ?.getBool(PreferenceKey.generalIsDevMode) ??
                          false;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.generalIsDevMode, !currentValue);
                    });
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: settingPageBoxDecoration(context),
                        padding: settingPageEdgeInsets(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '启用开发选项',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            )),
                            Switch(
                              value: HomeState.sharedPreferences?.getBool(
                                    PreferenceKey.generalIsDevMode,
                                  ) ??
                                  false,
                              onChanged: (bool value) {
                                setState(() {
                                  HomeState.sharedPreferences?.setBool(
                                      PreferenceKey.generalIsDevMode, value);
                                });
                              },
                            ),
                          ],
                        ),
                      )))
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

class LCDSettingPageState extends State<LCDSettingPage> {
  //设置各项参数的中间变量，用于不要在输入时直接修改参数，而是在按下确定按钮时修改
  late String maxStationToSet;

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
              const Text(
                'LCD 显示屏',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('允许的最大站点数量'),
                          content: TextField(
                            decoration: const InputDecoration(
                              hintText: '32',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: TextEditingController(
                                text: HomeState.sharedPreferences
                                        ?.getInt(PreferenceKey.lcdMaxStation)
                                        ?.toString() ??
                                    "32"),
                            onChanged: (String value) {
                              maxStationToSet = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (maxStationToSet.isEmpty) {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.lcdMaxStation, 32);
                                    Util.lcdMaxStation = 32;
                                  } else {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.lcdMaxStation,
                                        int.parse(maxStationToSet));
                                    Util.lcdMaxStation =
                                        int.parse(maxStationToSet);
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        );
                      });
                },
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        decoration: settingPageBoxDecoration(context),
                        padding: settingPageEdgeInsets(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '允许的最大站点数量',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '限制导入的线路信息文件中站点数量，默认为 32。调整数量可能会导致降低美观程度，或出现显示异常',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                HomeState.sharedPreferences
                                        ?.getInt(PreferenceKey.lcdMaxStation)
                                        ?.toString() ??
                                    "32",
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.grey),
                              ),
                            )
                          ],
                        ))),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences
                              ?.getBool(PreferenceKey.lcdIsBoldFont) ??
                          true;
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.lcdIsBoldFont, !currentValue);
                      Util.lcdBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        decoration: settingPageBoxDecoration(context),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '使用中粗体',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '下一站、当前站、终点站和站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ],
                            )),
                            Switch(
                              value: HomeState.sharedPreferences?.getBool(
                                    PreferenceKey.lcdIsBoldFont,
                                  ) ??
                                  true,
                              onChanged: (bool value) {
                                setState(() {
                                  HomeState.sharedPreferences?.setBool(
                                      PreferenceKey.lcdIsBoldFont, value);
                                  Util.lcdBoldFont = value
                                      ? FontWeight.w600
                                      : FontWeight.normal;
                                });
                              },
                            ),
                          ],
                        ),
                      )))
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

class ScreenDoorCoverSettingPageState
    extends State<ScreenDoorCoverSettingPage> {
  late String maxStationToSet;

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
              const Text(
                '屏蔽门盖板',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              //similar to LCDSettingPage
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('允许的最大站点数量'),
                          content: TextField(
                            decoration: const InputDecoration(
                              hintText: '36',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            controller: TextEditingController(
                                text: HomeState.sharedPreferences
                                        ?.getInt(PreferenceKey
                                            .screenDoorCoverMaxStation)
                                        ?.toString() ??
                                    "36"),
                            onChanged: (String value) {
                              maxStationToSet = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  if (maxStationToSet.isEmpty) {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.screenDoorCoverMaxStation,
                                        36);
                                    Util.screenDoorCoverMaxStation = 36;
                                  } else {
                                    HomeState.sharedPreferences?.setInt(
                                        PreferenceKey.screenDoorCoverMaxStation,
                                        int.parse(maxStationToSet));
                                    Util.screenDoorCoverMaxStation =
                                        int.parse(maxStationToSet);
                                  }
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        );
                      });
                },
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                        decoration: settingPageBoxDecoration(context),
                        padding: settingPageEdgeInsets(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '允许的最大站点数量',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  '限制导入的线路信息文件中站点数量，默认为 36。调整数量可能会导致降低美观程度，或出现显示异常',
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ],
                            )),
                            Container(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Text(
                                HomeState.sharedPreferences
                                        ?.getInt(PreferenceKey
                                            .screenDoorCoverMaxStation)
                                        ?.toString() ??
                                    "36",
                                style: const TextStyle(
                                    fontSize: 18.0, color: Colors.grey),
                              ),
                            )
                          ],
                        ))),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey.screenDoorCoverIsBoldFont) ??
                          true;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.screenDoorCoverIsBoldFont,
                          !currentValue);
                      Util.screenDoorCoverBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      decoration: settingPageBoxDecoration(context),
                      padding: settingPageEdgeInsets(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '使用中粗体',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              Text(
                                '下一站、当前站、终点站和站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey[600]),
                              ),
                            ],
                          )),
                          Switch(
                            value: HomeState.sharedPreferences?.getBool(
                                  PreferenceKey.screenDoorCoverIsBoldFont,
                                ) ??
                                true,
                            onChanged: (bool value) {
                              setState(() {
                                HomeState.sharedPreferences?.setBool(
                                    PreferenceKey.screenDoorCoverIsBoldFont,
                                    value);
                                Util.screenDoorCoverBoldFont =
                                    value ? FontWeight.w600 : FontWeight.normal;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

EdgeInsets settingPageEdgeInsets() => const EdgeInsets.all(10.0);

BoxDecoration settingPageBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? Colors.pink[50]
        : Util.darkColorScheme().onSecondary,
    borderRadius: BorderRadius.circular(10.0),
  );
}

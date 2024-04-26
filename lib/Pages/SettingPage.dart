import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/Preference.dart';
import 'package:main/main.dart';

import '../Util.dart';

//通用设置页面
class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "GennokiokuLCDFont",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: Scaffold(
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
                Row(
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
                          HomeState.sharedPreferences
                              ?.setBool(PreferenceKey.generalIsDevMode, value);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
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
  State<LCDSettingPage> createState() => _LCDSettingPageState();
}

class _LCDSettingPageState extends State<LCDSettingPage> {
  bool isDevMode = HomeState.sharedPreferences?.getBool(
        PreferenceKey.generalIsDevMode,
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "GennokiokuLCDFont",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: Scaffold(
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
                Row(
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
                    SizedBox(
                      height: 40.0,
                      width: 100.0,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: '32',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        controller: TextEditingController(
                            text: HomeState.sharedPreferences
                                    ?.getInt(PreferenceKey.lcdMaxStation)
                                    ?.toString() ??
                                "32"),
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            HomeState.sharedPreferences
                                ?.setInt(PreferenceKey.lcdMaxStation, 32);
                            Util.lcdMaxStation = 32;
                          } else {
                            HomeState.sharedPreferences?.setInt(
                                PreferenceKey.lcdMaxStation, int.parse(value));
                            Util.lcdMaxStation = int.parse(value);
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
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
                          HomeState.sharedPreferences
                              ?.setBool(PreferenceKey.lcdIsBoldFont, value);
                          Util.lcdBoldFont =
                              HomeState.sharedPreferences?.getBool(
                                        PreferenceKey.lcdIsBoldFont,
                                      ) ??
                                      true
                                  ? FontWeight.w600
                                  : FontWeight.normal;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
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
  State<ScreenDoorCoverSettingPage> createState() =>
      _ScreenDoorCoverSettingPageState();
}

class _ScreenDoorCoverSettingPageState
    extends State<ScreenDoorCoverSettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "GennokiokuLCDFont",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: Scaffold(
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
                Row(
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
                    SizedBox(
                      height: 40.0,
                      width: 100.0,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: '36',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        controller: TextEditingController(
                            text: HomeState.sharedPreferences
                                    ?.getInt(
                                        PreferenceKey.screenDoorCoverMaxStation)
                                    ?.toString() ??
                                "36"),
                        onChanged: (String value) {
                          if (value.isEmpty) {
                            HomeState.sharedPreferences?.setInt(
                                PreferenceKey.screenDoorCoverMaxStation, 36);
                            Util.screenDoorCoverMaxStation = 36;
                          } else {
                            HomeState.sharedPreferences?.setInt(
                                PreferenceKey.screenDoorCoverMaxStation,
                                int.parse(value));
                            Util.screenDoorCoverMaxStation = int.parse(value);
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
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
                          '站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
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
                              PreferenceKey.screenDoorCoverIsBoldFont, value);
                          Util.screenDoorCoverBoldFont =
                              HomeState.sharedPreferences?.getBool(
                                        PreferenceKey.screenDoorCoverIsBoldFont,
                                      ) ??
                                      true
                                  ? FontWeight.w600
                                  : FontWeight.normal;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

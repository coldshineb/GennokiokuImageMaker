import 'package:flutter/material.dart';

import '../../../Parent/SettingPage.dart';
import '../../../Preference.dart';
import '../../../Util.dart';
import '../../../main.dart';

class GeneralSettingPageRoot extends StatelessWidget {
  const GeneralSettingPageRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: LCDSettingPage());
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
          ?.getInt(PreferenceKey.railwayTransitLcdMaxStation)
          ?.toString() ??
      '${DefaultPreference.railwayTransitLcdMaxStation}';

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
                  '限制导入的线路信息文件中站点数量，默认为 ${DefaultPreference.railwayTransitLcdMaxStation}。调整数量可能会导致降低美观程度，或出现显示异常',
                  '${DefaultPreference.railwayTransitLcdMaxStation}',
                  HomeState.sharedPreferences
                          ?.getInt(PreferenceKey.railwayTransitLcdMaxStation)
                          ?.toString() ??
                      '${DefaultPreference.railwayTransitLcdMaxStation}', (String value) {
                maxStationToSet = value;
              }, () {
                setState(() {
                  if (maxStationToSet.isEmpty) {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.railwayTransitLcdMaxStation,
                        DefaultPreference.railwayTransitLcdMaxStation);
                    Util.railwayTransitLcdMaxStation = DefaultPreference.railwayTransitLcdMaxStation;
                  } else {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.railwayTransitLcdMaxStation,
                        int.parse(maxStationToSet));
                    Util.railwayTransitLcdMaxStation = int.parse(maxStationToSet);
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
                              ?.getBool(PreferenceKey.railwayTransitLcdIsBoldFont) ??
                          DefaultPreference.railwayTransitLcdIsBoldFont;
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.railwayTransitLcdIsBoldFont, !currentValue);
                      Util.railwayTransitLcdIsBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  '使用中粗体',
                  '下一站、当前站、终点站和站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.railwayTransitLcdIsBoldFont,
                      ) ??
                      DefaultPreference.railwayTransitLcdIsBoldFont,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences
                          ?.setBool(PreferenceKey.railwayTransitLcdIsBoldFont, value);
                      Util.railwayTransitLcdIsBoldFont =
                          value ? FontWeight.w600 : FontWeight.normal;
                    });
                  }),
              const SizedBox(height: 10.0),
              createSwitch(
                  context,
                  () {
                    setState(() {
                      bool currentValue = HomeState.sharedPreferences?.getBool(
                              PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor) ??
                          DefaultPreference.railwayTransitLcdIsRouteColorSameAsLineColor;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor,
                          !currentValue);
                      Util.railwayTransitLcdIsRouteColorSameAsLineColor = !currentValue;
                    });
                  },
                  '使用线路标识色作为未过站站点图标与线路线条颜色',
                  '默认为开启。关闭后则使用绿色，在一些线路标识色与已过站、下一站站点图标等预设颜色相近时，有助于颜色区分',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor,
                      ) ??
                      DefaultPreference.railwayTransitLcdIsRouteColorSameAsLineColor,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor, value);
                      Util.railwayTransitLcdIsRouteColorSameAsLineColor = value;
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
          ?.getInt(PreferenceKey.railwayTransitScreenDoorCoverMaxStation)
          ?.toString() ??
      "${DefaultPreference.railwayTransitScreenDoorCoverMaxStation}";

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
                  '限制导入的线路信息文件中站点数量，默认为 ${DefaultPreference.railwayTransitScreenDoorCoverMaxStation}。调整数量可能会导致降低美观程度，或出现显示异常',
                  '${DefaultPreference.railwayTransitScreenDoorCoverMaxStation}',
                  HomeState.sharedPreferences
                          ?.getInt(PreferenceKey.railwayTransitScreenDoorCoverMaxStation)
                          ?.toString() ??
                      "${DefaultPreference.railwayTransitScreenDoorCoverMaxStation}",
                  (String value) {
                maxStationToSet = value;
              }, () {
                setState(() {
                  if (maxStationToSet.isEmpty) {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.railwayTransitScreenDoorCoverMaxStation,
                        DefaultPreference.railwayTransitScreenDoorCoverMaxStation);
                    Util.railwayTransitScreenDoorCoverMaxStation =
                        DefaultPreference.railwayTransitScreenDoorCoverMaxStation;
                  } else {
                    HomeState.sharedPreferences?.setInt(
                        PreferenceKey.railwayTransitScreenDoorCoverMaxStation,
                        int.parse(maxStationToSet));
                    Util.railwayTransitScreenDoorCoverMaxStation = int.parse(maxStationToSet);
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
                              PreferenceKey.railwayTransitScreenDoorCoverIsBoldFont) ??
                          DefaultPreference.railwayTransitScreenDoorCoverIsBoldFont;
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.railwayTransitScreenDoorCoverIsBoldFont,
                          !currentValue);
                      Util.railwayTransitScreenDoorCoverIsBoldFont =
                          !currentValue ? FontWeight.w600 : FontWeight.normal;
                    });
                  },
                  '使用中粗体',
                  '站名的中英文显示是否使用中粗体，默认为开启。关闭后则以常规字体显示',
                  HomeState.sharedPreferences?.getBool(
                        PreferenceKey.railwayTransitScreenDoorCoverIsBoldFont,
                      ) ??
                      DefaultPreference.railwayTransitScreenDoorCoverIsBoldFont,
                  (bool value) {
                    setState(() {
                      HomeState.sharedPreferences?.setBool(
                          PreferenceKey.railwayTransitScreenDoorCoverIsBoldFont, value);
                      Util.railwayTransitScreenDoorCoverIsBoldFont =
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

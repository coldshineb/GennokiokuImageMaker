import 'package:flutter/material.dart';
import 'package:main/Pages/Roots.dart';
import 'package:main/Pages/ScreenDoorCover.dart';
import 'package:main/Preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/HomePage.dart';
import 'Pages/StationEntranceCover.dart';
import 'Util.dart';
import 'Util/CustomScrollBehavior.dart';

void main() async {
  SharedPreferences? sharedPreferences; // 持久化数据
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance(); // 获取持久化数据
  Preference.themeMode =
      sharedPreferences.getInt(PreferenceKey.generalThemeMode) == 2
          ? ThemeMode.dark
          : sharedPreferences.getInt(PreferenceKey.generalThemeMode) == 1
              ? ThemeMode.light
              : ThemeMode.system; //设置主题
  runApp(MaterialApp(
      theme: Util.themeData(),
      darkTheme: Util.darkThemeData(),
      themeMode: Preference.themeMode,
      scrollBehavior: CustomScrollBehavior(),
      //设置鼠标拖动滑动
      home: const Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAlignment = -1.0;
  static SharedPreferences? sharedPreferences; // 持久化数据

  // 设置持久化数据
  void loadPref() async {
    sharedPreferences = await SharedPreferences.getInstance(); // 获取持久化数据
    setState(() {
      //启用开发选项
      Preference.generalIsDevMode =
          sharedPreferences!.getBool(PreferenceKey.generalIsDevMode) ?? false;
      //LCD最大站点数
      Preference.lcdMaxStation =
          sharedPreferences!.getInt(PreferenceKey.lcdMaxStation) ?? 32;
      //屏蔽门盖板最大站点数
      Preference.screenDoorCoverMaxStation =
          sharedPreferences!.getInt(PreferenceKey.screenDoorCoverMaxStation) ??
              36;
      //LCD是否使用粗体
      Preference.lcdIsBoldFont =
          sharedPreferences!.getBool(PreferenceKey.lcdIsBoldFont) ?? true;
      //屏蔽门盖板是否使用粗体
      Preference.screenDoorCoverIsBoldFont =
          sharedPreferences!.getBool(PreferenceKey.screenDoorCoverIsBoldFont) ??
              true;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadPref();
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const LCDRoot();
        break;
      case 2:
        page = const StationEntranceCover();
        break;
      case 3:
        page = const ScreenDoorCover();
        break;
      case 4:
        page = const SettingPageRoot();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.pink[50]
            : Util.darkColorScheme().surface,
        title: const Text('Gennokioku 原忆轨道交通图片生成器'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.pink[50]
                : Util.darkColorScheme().surface,
            selectedIndex: _selectedIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.assistant_outlined),
                selectedIcon: Icon(Icons.assistant),
                label: Text('欢迎', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fit_screen_outlined),
                selectedIcon: Icon(Icons.fit_screen),
                label: Text('LCD 显示屏', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.signpost_outlined),
                selectedIcon: Icon(Icons.signpost),
                label: Text('出入口盖板', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.splitscreen_outlined),
                selectedIcon: Icon(Icons.splitscreen),
                label: Text('屏蔽门盖板', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('设置', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          )),
        ],
      ),
    );
  }
}

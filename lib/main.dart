import 'package:flutter/material.dart';
import 'package:main/Preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/HomePage.dart';
import 'Pages/RailwayTransit/Roots.dart';
import 'Pages/RailwayTransit/SettingPage.dart';
import 'Pages/RoadSign/Roots.dart';
import 'Pages/SettingPage.dart';
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
      title: 'Gennokioku 原忆图片生成器',
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
  Future<int> loadPref() async {
    sharedPreferences = await SharedPreferences.getInstance(); // 获取持久化数据
    setState(() {
      //深色主题下使用白色背景
      Preference.generalIsWhiteBackgroundInDarkMode = sharedPreferences!
              .getBool(PreferenceKey.generalIsWhiteBackgroundInDarkMode) ??
          DefaultPreference.generalIsWhiteBackgroundInDarkMode;
      //启用缩放和自由滑动
      Preference.generalIsScaleEnabled =
          sharedPreferences!.getBool(PreferenceKey.generalIsScaleEnabled) ??
              DefaultPreference.generalIsScaleEnabled;
      //启用开发选项
      Preference.generalIsDevMode =
          sharedPreferences!.getBool(PreferenceKey.generalIsDevMode) ??
              DefaultPreference.generalIsDevMode;
    });
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.pink[50]
            : Util.darkColorScheme().surface,
        centerTitle: false,
        title: const Text('Gennokioku 原忆图片生成器'),
      ),
      body: FutureBuilder(
        //因IndexedStack一次性加载所有页面，因此使用FutureBuilder提前读取设置
        future: loadPref(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: NavigationRail(
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.light
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
                                  label: Text('欢迎',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.train_outlined),
                                  selectedIcon: Icon(Icons.train),
                                  label: Text('轨道交通',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.signpost_outlined),
                                  selectedIcon: Icon(Icons.signpost),
                                  label: Text('路牌',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                NavigationRailDestination(
                                  icon: Icon(Icons.settings_outlined),
                                  selectedIcon: Icon(Icons.settings),
                                  label: Text('设置',
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ],
                            ),
                          )));
                }),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                    child: IndexedStack(
                  index: _selectedIndex,
                  children: const <Widget>[
                    HomePage(),
                    RailwayTransitRoot(),
                    RoadSignRoot(),
                    GeneralSettingPage(),
                  ],
                )),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:main/Pages/Roots.dart';

import 'Pages/StationEntranceCover.dart';
import 'Util/CustomScrollBehavior.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: "GennokiokuLCDFont",
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
      ),
    ),
    scrollBehavior: CustomScrollBehavior(), //设置鼠标拖动滑动
    home: const Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const LCDRoot();
        break;
      case 1:
        page = StationEntranceCover();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('原忆轨道交通图片生成器'),
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
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
                icon: Icon(Icons.fit_screen_outlined),
                selectedIcon: Icon(Icons.fit_screen),
                label: Text('LCD 显示屏', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.signpost_outlined),
                selectedIcon: Icon(Icons.signpost),
                label: Text('出入口盖板', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
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

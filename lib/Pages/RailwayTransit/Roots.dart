import 'package:flutter/material.dart';

import 'LCD/ArrivalFiveStations.dart';
import 'LCD/ArrivalLinearRoute.dart';
import 'LCD/ArrivalStationInfo.dart';
import 'LCD/RunningLinearRoute.dart';
import 'ScreenDoorCover.dart';
import 'SettingPage.dart';
import 'StationEntrance/StationEntranceCover.dart';
import 'StationEntrance/StationEntranceSideName.dart';

//轨道交通二级导航
class RailwayTransitRoot extends StatefulWidget {
  const RailwayTransitRoot({super.key});

  @override
  State<RailwayTransitRoot> createState() => _RailwayTransitRootState();
}

class _RailwayTransitRootState extends State<RailwayTransitRoot> {
  int _selectedIndex = 0;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    groupAlignment: groupAlignment,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.fit_screen_outlined),
                        selectedIcon: Icon(Icons.fit_screen),
                        label: Text('LCD 显示屏', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.signpost_outlined),
                        selectedIcon: Icon(Icons.signpost),
                        label: Text('出入口图片', style: TextStyle(fontSize: 15)),
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
                ),
              ),
            );
          }),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              child:
                  IndexedStack(index: _selectedIndex, children: const <Widget>[
            LCDRoot(),
            StationEntranceRoot(),
            ScreenDoorCover(),
            RailwayTransitSettingPageRoot(),
          ])),
        ],
      ),
    );
  }
}

//LCD 显示屏三级导航
class LCDRoot extends StatefulWidget {
  const LCDRoot({super.key});

  @override
  State<LCDRoot> createState() => _LCDRootState();
}

class _LCDRootState extends State<LCDRoot> {
  int _selectedIndex = 0;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    extended: true,
                    selectedIndex: _selectedIndex,
                    groupAlignment: groupAlignment,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_takeoff),
                        selectedIcon: Icon(Icons.flight_takeoff),
                        label:
                            Text('运行中 直线型线路图', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_land),
                        selectedIcon: Icon(Icons.flight_land),
                        label: Text('已到站 五站图', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_land),
                        selectedIcon: Icon(Icons.flight_land),
                        label:
                            Text('已到站 站点信息图', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_land),
                        selectedIcon: Icon(Icons.flight_land),
                        label:
                            Text('已到站 直线型线路图', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              RunningLinearRoute(),
              ArrivalFiveStations(),
              ArrivalStationInfo(),
              ArrivalLinearRoute(),
            ],
              )),
        ],
      ),
    );
  }
}

//出入口图片三级导航
class StationEntranceRoot extends StatefulWidget {
  const StationEntranceRoot({super.key});

  @override
  State<StationEntranceRoot> createState() => _StationEntranceRootState();
}

class _StationEntranceRootState extends State<StationEntranceRoot> {
  int _selectedIndex = 0;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const StationEntranceCover();
        break;
      case 1:
        page = const StationEntranceSideName();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: NavigationRail(
                  extended: true,
                  selectedIndex: _selectedIndex,
                  groupAlignment: groupAlignment,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.signpost_outlined),
                      selectedIcon: Icon(Icons.signpost),
                      label: Text('出入口盖板', style: TextStyle(fontSize: 15)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.signpost_outlined),
                      selectedIcon: Icon(Icons.signpost),
                      label: Text('出入口侧方站名', style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ));
          }),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              child: Container(
            child: page,
          )),
        ],
      ),
    );
  }
}

//轨道交通设置三级导航
class RailwayTransitSettingPageRoot extends StatefulWidget {
  const RailwayTransitSettingPageRoot({super.key});

  @override
  State<RailwayTransitSettingPageRoot> createState() =>
      _RailwayTransitSettingPageRootState();
}

class _RailwayTransitSettingPageRootState
    extends State<RailwayTransitSettingPageRoot> {
  int _selectedIndex = 0;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const LCDSettingPage();
        break;
      case 1:
        page = const ScreenDoorCoverSettingPage();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    groupAlignment: groupAlignment,
                    labelType: NavigationRailLabelType.all,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.fit_screen_outlined),
                        selectedIcon: Icon(Icons.fit_screen),
                        label: Text('LCD 显示屏', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.splitscreen_outlined),
                        selectedIcon: Icon(Icons.splitscreen),
                        label: Text('屏蔽门盖板', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
              child: Container(
            child: page,
          )),
        ],
      ),
    );
  }
}

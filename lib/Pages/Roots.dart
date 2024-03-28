import 'package:flutter/material.dart';
import 'package:main/Pages/LCD/RunningLinearRoute.dart';

import 'LCD/ArrivalFiveStations.dart';
import 'LCD/ArrivalLinearRoute.dart';
import 'LCD/ArrivalStationInfo.dart';

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
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = RunningLinearRoute();
        break;
      case 1:
        page = ArrivalFiveStations();
        break;
      case 2:
        page = ArrivalStationInfo();
        break;
      case 3:
        page = ArrivalLinearRoute();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
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
                label: Text('运行中 直线型线路图', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.flight_land),
                selectedIcon: Icon(Icons.flight_land),
                label: Text('已到站 五站图', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.flight_land),
                selectedIcon: Icon(Icons.flight_land),
                label: Text('已到站 站点信息图', style: TextStyle(fontSize: 15)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.flight_land),
                selectedIcon: Icon(Icons.flight_land),
                label: Text('已到站 直线型线路图', style: TextStyle(fontSize: 15)),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1,width: 1),
          Expanded(
              child: Container(
            child: page,
          )),
        ],
      ),
    );
  }
}

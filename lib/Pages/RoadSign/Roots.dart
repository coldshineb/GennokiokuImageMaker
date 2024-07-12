import 'package:flutter/material.dart';

import 'RoadSign.dart';

//路牌二级导航
class RoadSignRoot extends StatefulWidget {
  const RoadSignRoot({super.key});

  @override
  State<RoadSignRoot> createState() => _RoadSignRootState();
}

class _RoadSignRootState extends State<RoadSignRoot> {
  int _selectedIndex = 0;
  double groupAlignment = -1.0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const RoadSign();
        break;
      case 1:
        page = const RoadSign();
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
                      label: Text('路牌', style: TextStyle(fontSize: 15)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.signpost_outlined),
                      selectedIcon: Icon(Icons.signpost),
                      label: Text('路牌', style: TextStyle(fontSize: 15)),
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

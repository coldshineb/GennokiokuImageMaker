import 'package:flutter/material.dart';

import 'Arrival.dart';
import 'Departure.dart';
import 'Platform.dart';
import 'Rule.dart';

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
                        icon: Icon(Icons.rule),
                        selectedIcon: Icon(Icons.rule),
                        label: Text('规范', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.train_outlined),
                        selectedIcon: Icon(Icons.train),
                        label: Text('站台', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_takeoff),
                        selectedIcon: Icon(Icons.flight_takeoff),
                        label: Text('出发', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.flight_land),
                        selectedIcon: Icon(Icons.flight_land),
                        label: Text('到站', style: TextStyle(fontSize: 15)),
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
                Rule(),
                Platform(),
                Departure(),
                Arrival()
              ])),
        ],
      ),
    );
  }
}

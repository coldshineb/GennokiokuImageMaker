import 'package:flutter/material.dart';

import 'RailwayTransit/Roots.dart';
import 'RoadSign/Roots.dart';

class ImageMakerRoot extends StatefulWidget {
  const ImageMakerRoot({super.key});

  @override
  State<ImageMakerRoot> createState() => _ImageMakerRootState();
}

class _ImageMakerRootState extends State<ImageMakerRoot> {
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
                        icon: Icon(Icons.train_outlined),
                        selectedIcon: Icon(Icons.train),
                        label: Text('轨道交通', style: TextStyle(fontSize: 15)),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.signpost_outlined),
                        selectedIcon: Icon(Icons.signpost),
                        label: Text('路牌', style: TextStyle(fontSize: 15)),
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
                RailwayTransitRoot(),
                RoadSignRoot()
              ])),
        ],
      ),
    );
  }
}

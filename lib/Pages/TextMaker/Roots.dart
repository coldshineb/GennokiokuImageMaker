import 'package:flutter/material.dart';

import 'RailwayTransit/Roots.dart';

class TextMakerRoot extends StatefulWidget {
  const TextMakerRoot({super.key});

  @override
  State<TextMakerRoot> createState() => _TextMakerRootState();
}

class _TextMakerRootState extends State<TextMakerRoot> {
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
                        icon: Icon(Icons.question_mark),
                        selectedIcon: Icon(Icons.question_mark),
                        label: Text('其他功能', style: TextStyle(fontSize: 15)),
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
                Placeholder()
              ])),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:main/Pages/LCD/ArrivalFiveStations.dart';
import 'package:main/Pages/LCD/ArrivalLinearRoute.dart';
import 'package:main/Pages/LCD/RunningLinearRoute.dart';

import 'Pages/LCD/ArrivalStationInfo.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('原忆轨道交通 LCD 生成器'),
        ),
        body: Row(
          children: [
            Center(
              child: ElevatedButton(
                  child: const Text('运行中 直线型线路图'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RunningLinearRoute()),
                    );
                  }),
            ),
            Center(
              child: ElevatedButton(
                  child: const Text('已到站 五站图'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivalFiveStations()),
                    );
                  }),
            ),
            Center(
              child: ElevatedButton(
                  child: const Text('已到站 站点信息图'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivalStationInfo()),
                    );
                  }),
            ),
            Center(
              child: ElevatedButton(
                  child: const Text('已到站 直线型线路图'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArrivalLinearRoute()),
                    );
                  }),
            ),
          ],
        ));
  }
}

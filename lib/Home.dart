import 'package:flutter/material.dart';

import 'Util/CustomScrollBehavior.dart';
import 'main.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      fontFamily: "GennokiokuLCDFont",
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pink,
      ),
    ),
    scrollBehavior: CustomScrollBehavior(),//设置鼠标拖动滑动
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
        title:
            const Text('原忆轨道交通 LCD 生成器'),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('直线型线路图 运行中'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }),
      ),
    );
  }
}

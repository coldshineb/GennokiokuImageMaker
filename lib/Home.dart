import 'package:flutter/material.dart';

import 'Util/CustomScrollBehavior.dart';
import 'main.dart';

void main() {
  runApp(MaterialApp(
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
            const Text('欢迎使用原忆轨道交通 LCD 生成器', style: TextStyle(fontFamily: "GennokiokuLCDFont")),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('直线型线路图 运行中',
                style: TextStyle(fontFamily: "GennokiokuLCDFont")),
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

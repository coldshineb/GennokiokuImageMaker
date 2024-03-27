import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Util.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "GennokiokuLCDFont",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '欢迎使用 Gennokioku 原忆轨道交通图片生成器',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '开始使用',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '请参阅帮助文档',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        "https://wiki.gennokioku.city/help-navigation/"));
                  },
                  child: const Text("打开 Gennokioku 原忆知识库帮助导航")),
              const SizedBox(height: 20.0),
              const Text(
                '关于',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                '批量生成原忆轨道交通中使用的 LCD 图片、设施告示牌、灯箱图片等资源',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '版本信息',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                Util.appVersion,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                '版权信息',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                Util.copyright,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

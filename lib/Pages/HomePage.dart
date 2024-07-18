import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Util.dart';

class HomePageRoot extends StatelessWidget {
  const HomePageRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '欢迎使用 Gennokioku 原忆图片生成器',
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
                '批量生成原忆中使用的轨道交通 LCD 图片、设施告示牌、灯箱图片等资源',
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
                !kIsWeb ? Util.appVersion : '滚动更新',
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
              const SizedBox(height: 10.0),
              ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        "https://github.com/coldshineb/GennokiokuImageMaker/"));
                  },
                  child: const Text("项目地址")),
              const SizedBox(height: 20.0),
              const Text(
                !kIsWeb ? '软件更新' : '软件下载',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(children: [
                ElevatedButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://github.com/coldshineb/GennokiokuImageMaker/actions/workflows/build_app.yml"));
                    },
                    child: const Text("下载开发版")),
                ElevatedButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://github.com/coldshineb/GennokiokuImageMaker/releases/latest"));
                    },
                    child: const Text("下载稳定版"))
              ]),
              const Divider(
                height: 20.0,
                thickness: 1.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        "https://github.com/coldshineb/GennokiokuImageMaker/issues/new?assignees=&labels=&projects=&template=%E9%94%99%E8%AF%AF%E6%8A%A5%E5%91%8A.md&title="));
                  },
                  child: const Text("错误报告"))
            ],
          ),
        ),
      ),
    );
  }
}

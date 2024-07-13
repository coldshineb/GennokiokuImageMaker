// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/EntranceCover.dart';

import '../../../Util.dart';
import '../../Parent/RoadSign/RoadSign.dart' as RoadSignParent;
import '../../Preference.dart';

class RoadSignRoot extends StatelessWidget {
  const RoadSignRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: const RoadSign(),
    );
  }
}

class RoadSign extends StatefulWidget {
  const RoadSign({super.key});

  @override
  RoadSignState createState() => RoadSignState();
}

class RoadSignState extends State<RoadSign> with RoadSignParent.RoadSign {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 240;
  static const double imageWidth = 720;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  TextEditingController roadNameController = TextEditingController(); //路名输入框控制器

  //默认导出宽度
  int exportWidthValue = 1920;

  @override
  Widget build(BuildContext context) {
    //loadFont();
    return Scaffold(
      backgroundColor: Util.backgroundColor(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              importAndExportMenubar(),
              MenuBar(style: menuStyle(context), children: [
                Container(
                    padding: const EdgeInsets.only(top: 14, left: 7),
                    child: const Text("方向")),
              ])
            ],
          ),
          Expanded(
            child: body(),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              padding: const EdgeInsets.only(right: 15),
              child: FloatingActionButton(
                onPressed: () {
                  //重置所有变量
                  _imageBytes = null;
                  setState(() {});
                },
                tooltip: '重置',
                child: const Icon(Icons.refresh),
              )),
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {});
              },
              tooltip: '刷新设置',
              child: const Icon(Icons.settings_backup_restore),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              exportMainImage();
            },
            tooltip: '导出',
            child: const Icon(Icons.save),
          )
        ],
      ),
    );
  }

  //主体部分
  SingleChildScrollView body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, //设置可水平、竖直滑动
          child: Column(
            children: [
              RepaintBoundary(
                key: _mainImageKey,
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                      ),
                      _imageBytes != null
                          ? SizedBox(
                              height: imageHeight,
                              child: Image.memory(
                                _imageBytes!,
                              ),
                            )
                          : const SizedBox(),
                      Positioned(
                          child: Container(
                        height: imageHeight / 2,
                        width: imageWidth,
                        color: Util.hexToColor("a5e6ed"),
                      )),
                      Positioned(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 10),
                                  height: imageHeight,
                                  width: imageWidth,
                                  child: TextField(
                                    controller: roadNameController,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 60,
                                        fontFamily: "HYYanKaiW"),
                                    decoration: const InputDecoration.collapsed(
                                      hintText: "中文路名",
                                      hintStyle: TextStyle(
                                          fontSize: 60,
                                          fontFamily: "GennokiokuLCDFont"),
                                    ),
                                  ),
                                ),
                              ])),
                      Positioned(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 140),
                                  height: imageHeight,
                                  width: imageWidth,
                                  child: const TextField(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50,
                                        fontFamily: "HYYanKaiW",color: Colors.black),
                                    decoration: InputDecoration.collapsed(
                                      hintText: "英文路名",
                                      hintStyle: TextStyle(
                                          fontSize: 50,
                                          fontFamily: "GennokiokuLCDFont",color: Colors.black),
                                    ),
                                  ),
                                ),
                              ]))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  //导出当前图
  Future<void> exportMainImage() async {
    String fileName = "路牌 ${roadNameController.text}.png";
    await exportImage(context, _mainImageKey, fileName, false,
        exportWidthValue: exportWidthValue);
  }
}

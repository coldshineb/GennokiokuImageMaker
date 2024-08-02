// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../../../Util.dart';
import '../../Parent/ImageMaker/RoadSign/RoadSign.dart' as RoadSignParent;

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

  //方向
  int position = 0;

  //是否反转方向
  bool reversePosition = false;

  //方向标记
  late String positionMarkLeft;
  late String positionMarkLeftEn;
  late String positionMarkRight;
  late String positionMarkRightEn;

  //路名输入框控制器
  TextEditingController roadNameController = TextEditingController();
  TextEditingController roadNameEnController = TextEditingController();

  //默认导出宽度
  int exportWidthValue = 1920;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: const Text("方位")),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                      value: 0,
                      groupValue: position,
                      onChanged: (v) {
                        setState(() {
                          position = v!;
                        });
                      },
                      child: const Text("东西")),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                      value: 1,
                      groupValue: position,
                      onChanged: (v) {
                        setState(() {
                          position = v!;
                        });
                      },
                      child: const Text("南北")),
                ),
                Container(
                    height: 48,
                    child: CheckboxMenuButton(
                      value: reversePosition,
                      onChanged: (bool? value) {
                        reversePosition = value!;
                        setState(() {});
                      },
                      child: const Text("反转方位"),
                    )),
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
                  roadNameController.clear();
                  roadNameEnController.clear();
                  position = 0;
                  reversePosition = false;
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
                      Positioned(
                          child: Container(
                        height: imageHeight / 2,
                        width: imageWidth,
                        color: Util.hexToColor("a5e6ed"),
                      )),
                      roadName(),
                      roadNameEn(),
                      positionMark()
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Container positionMark() {
    positionMarkLeft = position == 0 ? "东" : "南";
    positionMarkLeftEn = position == 0 ? "E" : "S";
    positionMarkRight = position == 0 ? "西" : "北";
    positionMarkRightEn = position == 0 ? "W" : "N";
    if (reversePosition) {
      String temp = positionMarkLeft;
      positionMarkLeft = positionMarkRight;
      positionMarkRight = temp;
      temp = positionMarkLeftEn;
      positionMarkLeftEn = positionMarkRightEn;
      positionMarkRightEn = temp;
    }
    return Container(
      height: imageHeight,
      width: imageWidth,
      child: Stack(
        children: [
          Positioned(
              top: 15,
              left: 20,
              child: Text(positionMarkLeft,
                  style: const TextStyle(
                      fontSize: 50, fontFamily: "GennokiokuLCDFont"))),
          Positioned(
              top: 15,
              right: 20,
              child: Text(positionMarkRight,
                  style: const TextStyle(
                      fontSize: 50, fontFamily: "GennokiokuLCDFont"))),
          Positioned(
              top: 136,
              left: 25,
              child: Text(positionMarkLeftEn,
                  style: const TextStyle(
                      fontSize: 50,
                      fontFamily: "GennokiokuLCDFont",
                      color: Colors.black))),
          Positioned(
              top: 136,
              right: 25,
              child: Text(positionMarkRightEn,
                  style: const TextStyle(
                      fontSize: 50,
                      fontFamily: "GennokiokuLCDFont",
                      color: Colors.black)))
        ],
      ),
    );
  }

  //英文路名
  Positioned roadNameEn() {
    return Positioned(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.only(top: 140),
        height: imageHeight,
        width: imageWidth,
        child: TextField(
          controller: roadNameEnController,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 50,
              fontFamily: "GennokiokuLCDFont",
              color: Colors.black),
          decoration: const InputDecoration.collapsed(
            hintText: "英文路名",
            hintStyle: TextStyle(
                fontSize: 50,
                fontFamily: "GennokiokuLCDFont",
                color: Colors.black),
          ),
        ),
      ),
    ]));
  }

  //路名
  Positioned roadName() {
    return Positioned(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.only(top: 10),
        height: imageHeight,
        width: imageWidth,
        child: TextField(
          controller: roadNameController,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 60, fontFamily: "HYYanKaiW"),
          decoration: const InputDecoration.collapsed(
            hintText: "中文路名",
            hintStyle: TextStyle(fontSize: 60, fontFamily: "GennokiokuLCDFont"),
          ),
        ),
      ),
    ]));
  }

  //导出当前图
  Future<void> exportMainImage() async {
    String fileName =
        "路牌 ${roadNameController.text} $positionMarkLeft$positionMarkRight.png";
    await exportImage(context, _mainImageKey, fileName, false,
        exportWidthValue: exportWidthValue);
  }
}

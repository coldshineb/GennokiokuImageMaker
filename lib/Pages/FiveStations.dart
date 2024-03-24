// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/Object/Station.dart';
import '../Parent/LCD.dart';
import '../Util.dart';
import '../Util/CustomColors.dart';
import '../Util/CustomPainter.dart';
import '../Util/Widgets.dart';

void loadFont() async {
  var fontLoader1 = FontLoader("GennokiokuLCDFont");
  fontLoader1
      .addFont(rootBundle.load('assets/font/FZLTHProGlobal-Regular.TTF'));
  var fontLoader2 = FontLoader("STZongyi");
  fontLoader2.addFont(rootBundle.load('assets/font/STZongyi.ttf'));
  await fontLoader1.load();
  await fontLoader2.load();
}

class FiveStationsRoot extends StatelessWidget {
  const FiveStationsRoot({super.key});

  @override
  Widget build(BuildContext context) {
    loadFont();
    return MaterialApp(
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: FiveStations(),
    );
  }
}

class FiveStations extends StatefulWidget {
  @override
  FiveStationsState createState() => FiveStationsState();
}

class FiveStationsState extends State<FiveStations> with LCD {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 335;
  static const double imageWidth = 1715.2;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _passingImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //站名集合
  List<Station> stationList = [];

  String lineNumber = "";
  String lineNumberEN = "";

  //线路颜色和颜色变体，默认透明，导入文件时赋值
  Color lineColor = Colors.transparent;
  Color lineVariantColor = Colors.transparent;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? currentStationListValue;
  String? terminusListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? currentStationListIndex;
  int? terminusListIndex;

  //运行方向，用于处理下一站与终点站为中间某一站时的线条显示，0为向左行，1为向右行
  int trainDirectionValue = 1;

  //默认导出宽度
  int exportWidthValue = 2560;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '返回',
        ),
        title: const Text('五站图 已到站'),
        elevation: 20,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuBar(children: [
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: _importImage,
                    child: const Text(
                      "导入图片",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: importLineJson,
                    child: const Text(
                      "导入线路",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const VerticalDivider(),
                const VerticalDivider(),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportAllImage,
                    child: const Text(
                      "导出全部图",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportDynamicImage,
                    child: const Text(
                      "导出当前站全部图",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const VerticalDivider(),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportMainImage,
                    child: const Text(
                      "导出主线路图",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportPassingImage,
                    child: const Text(
                      "导出下一站图",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text(
                    "导出分辨率",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownButton(
                  items: Widgets.resolutionList(),
                  onChanged: (value) {
                    setState(() {
                      exportWidthValue = value!;
                    });
                  },
                  value: exportWidthValue,
                ),
              ]),
              MenuBar(children: [
                Container(
                  padding: const EdgeInsets.only(top: 14, left: 7),
                  child: const Text(
                    "当前站",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "当前站",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ), //设置空时的提示文字
                  items: showStationList(stationList),
                  onChanged: (value) {
                    if ((stationList.indexWhere((element) =>
                                    element.stationNameCN == value) -
                                terminusListIndex!)
                            .abs() >=
                        2) {
                      try {
                        currentStationListIndex = stationList.indexWhere(
                            (element) =>
                                element.stationNameCN ==
                                value); //根据选择的站名，找到站名集合中对应的索引
                        currentStationListValue = value;
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      alertDialog("错误", "当前站与终点站间隔不能小于 2");
                    }
                  },
                  value: currentStationListValue,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text(
                    "终点站",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "终点站",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  items: showStationList(stationList),
                  onChanged: (value) {
                    if ((stationList.indexWhere((element) =>
                                    element.stationNameCN == value) -
                                currentStationListIndex!)
                            .abs() >=
                        2) {
                      try {
                        terminusListIndex = stationList.indexWhere(
                            (element) => element.stationNameCN == value);
                        terminusListValue = value;
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      alertDialog("错误", "当前站与终点站间隔不能小于 2");
                    }
                  },
                  value: terminusListValue,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text(
                    "注意：到站时的线路图仅支持五站图，不要让当前站在终点站左边时，终点站为前四站；当前站在终点站右边时，终点站为末四站。程序会崩溃，没有任何提示。",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ])
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, //设置可水平、竖直滑动
                  child: Column(
                    children: [
                      //主线路图
                      RepaintBoundary(
                        key: _mainImageKey,
                        child: Container(
                          color: Util.hexToColor(CustomColors.backgroundColor),
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
                              Container(
                                  //原忆轨道交通图标
                                  padding:
                                      const EdgeInsets.fromLTRB(22.5, 5, 0, 0),
                                  alignment: Alignment.topLeft,
                                  height: 274,
                                  width: 274,
                                  child: SvgPicture.string(
                                      Util.railwayTransitLogo)),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(270, 16, 0, 0),
                                child: Widgets.lineNumberIcon(
                                    lineColor, lineNumber, lineNumberEN),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(522.5, 8, 0, 0),
                                  child: const Text(
                                    "当前站",
                                    style: TextStyle(fontSize: 28
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      516.5, 41, 0, 0),
                                  child: const Text(
                                    "Current station",
                                    style: TextStyle(fontSize: 14
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(911.5, 8, 0, 0),
                                  child: const Text(
                                    "终点站",
                                    style: TextStyle(fontSize: 28
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      924.5, 41, 0, 0),
                                  child: const Text(
                                    "Terminus",
                                    style: TextStyle(fontSize: 14
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(619, 8, 0, 0),
                                  child: Text(
                                    currentStationListIndex == null
                                        ? ""
                                        : stationList[currentStationListIndex!]
                                            .stationNameCN,
                                    //默认时索引为空，不显示站名；不为空时根据索引对应站名显示
                                    style: const TextStyle(fontSize: 28
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      1010.5, 8, 0, 0),
                                  child: Text(
                                    terminusListIndex == null
                                        ? ""
                                        : stationList[terminusListIndex!]
                                            .stationNameCN,
                                    style: const TextStyle(fontSize: 28
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      619.5, 41, 0, 0),
                                  child: Text(
                                    currentStationListIndex == null
                                        ? ""
                                        : stationList[currentStationListIndex!]
                                            .stationNameEN,
                                    style: const TextStyle(fontSize: 14
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      1010.5, 41, 0, 0),
                                  child: Text(
                                    terminusListIndex == null
                                        ? ""
                                        : stationList[terminusListIndex!]
                                            .stationNameEN,
                                    style: const TextStyle(fontSize: 14
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  width: imageWidth,
                                  height: imageHeight,
                                  child: showStationName()),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(200, 195, 0, 0),
                                //child: showRouteLine(),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                //child: showRouteIcon(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //下一站图
                      RepaintBoundary(
                        key: _passingImageKey,
                        child: Container(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: imageWidth,
                                height: imageHeight,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                child: showPassingRouteIcon(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
      //重置按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //重置所有变量
          _imageBytes = null;
          stationList.clear();
          lineColor = Colors.transparent;
          lineVariantColor = Colors.transparent;
          currentStationListIndex = null;
          terminusListIndex = null;
          currentStationListValue = null;
          terminusListValue = null;
          lineNumber = "";
          lineNumberEN = "";
          setState(() {});
        },
        tooltip: '重置',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  //显示线路
  Stack showRouteLine() {
    List<Container> lineList = [];
    //显示整条线，默认为已过站
    for (int i = 0; i < stationList.length - 1; i++) {
      lineList.add((routeLine(i, Util.hexToColor(CustomColors.passedStation))));
    }
    //根据选择的下一站和终点站，替换已过站为未过站
    if (currentStationListIndex != null && terminusListIndex != null) {
      List<Container> replaceList = [];
      //非空判断
      //下一站在终点站左侧
      if (currentStationListIndex! < terminusListIndex!) {
        //下一站不为起始站
        if (currentStationListIndex != 0) {
          for (int i = currentStationListIndex! - 1;
              i < terminusListIndex!;
              i++) {
            //nextStationListIndex-1：下一站前的线条
            replaceList.add(routeLine(i, lineColor));
          }
          //替换原集合
          lineList.replaceRange(
              currentStationListIndex! - 1, terminusListIndex!, replaceList);
        } else
        //下一站为起始站
        {
          for (int i = currentStationListIndex!; i < terminusListIndex!; i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(
              currentStationListIndex!, terminusListIndex!, replaceList);
        }
      }
      //下一站在终点站右侧
      else if (currentStationListIndex! > terminusListIndex!) {
        //下一站不为终点站
        if (currentStationListIndex != stationList.length - 1) {
          for (int i = terminusListIndex!;
              i < currentStationListIndex! + 1;
              i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(
              terminusListIndex!, currentStationListIndex! + 1, replaceList);
        } else
        //下一站为终点站
        {
          for (int i = terminusListIndex!; i < currentStationListIndex!; i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(
              terminusListIndex!, currentStationListIndex!, replaceList);
        }
      } else {
        //下一站为首站
        if (currentStationListIndex == 0) {
          replaceList.add(Container(
            //最左侧，不用间隔
            height: 15,
            child: Container(
              width: (1400 / (stationList.length - 1)),
              color: lineColor,
            ),
          ));
          lineList.replaceRange(0, 1, replaceList);
        }
        //下一站为尾站
        else if (currentStationListIndex == stationList.length - 1) {
          replaceList.add(Container(
            padding: EdgeInsets.only(
                left: (1400 / (stationList.length - 1)) *
                    (stationList.length - 2)),
            //最右侧
            height: 15,
            child: Container(
              width: (1400 / (stationList.length - 1)),
              color: lineColor,
            ),
          ));
          lineList.replaceRange(
              stationList.length - 2, stationList.length - 1, replaceList);
        }
        //下一站与终点站相同，但不为首尾站
        else {
          //向左行
          if (trainDirectionValue == 0) {
            replaceList.add(Container(
              padding: EdgeInsets.only(
                  left: (1400 / (stationList.length - 1)) *
                      currentStationListIndex!),
              height: 15,
              child: Container(
                width: (1400 / (stationList.length - 1)),
                color: lineColor,
              ),
            ));
            lineList.replaceRange(currentStationListIndex!,
                currentStationListIndex! + 1, replaceList);
          }
          //向右行
          else {
            replaceList.add(Container(
              padding: EdgeInsets.only(
                  left: (1400 / (stationList.length - 1)) *
                      (currentStationListIndex! - 1)),
              height: 15,
              child: Container(
                width: (1400 / (stationList.length - 1)),
                color: lineColor,
              ),
            ));
            lineList.replaceRange(currentStationListIndex! - 1,
                currentStationListIndex!, replaceList);
          }
        }
      }
    }
    return Stack(
      children: lineList,
    );
  }

  //线路
  Container routeLine(int i, Color color) {
    return Container(
      padding: EdgeInsets.only(left: (1400 / (stationList.length - 1)) * i),
      //间隔
      height: 15,
      child: Container(
        width: (1400 / (stationList.length - 1)), //每个站与站之间线条的宽度
        color: color,
      ),
    );
  }

  //显示站点图标  与 showRouteLine 类似
  Stack showRouteIcon() {
    List<Container> iconList = [];
    for (int i = 0; i < stationList.length; i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stationList.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: StationIconSmallPainter(
                lineColor: Util.hexToColor(CustomColors.passedStation),
                lineVariantColor:
                    Util.hexToColor(CustomColors.passedStationVariant),
                shadow: true),
          )));
    }
    if (currentStationListIndex != null && terminusListIndex != null) {
      if (currentStationListIndex! <= terminusListIndex!) {
        List<Container> replaceList = [];
        for (int i = currentStationListIndex!;
            i < terminusListIndex! + 1;
            i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (1400 / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: StationIconSmallPainter(
                    lineColor: lineColor,
                    lineVariantColor: lineVariantColor,
                    shadow: true),
              )));
        }
        iconList.replaceRange(
            currentStationListIndex!, terminusListIndex! + 1, replaceList);
      } else if (currentStationListIndex! > terminusListIndex!) {
        List<Container> replaceList = [];
        for (int i = terminusListIndex!;
            i < currentStationListIndex! + 1;
            i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (1400 / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: StationIconSmallPainter(
                    lineColor: lineColor,
                    lineVariantColor: lineVariantColor,
                    shadow: true),
              )));
        }
        iconList.replaceRange(
            terminusListIndex!, currentStationListIndex! + 1, replaceList);
      }
    }
    return Stack(
      children: iconList,
    );
  }

  //显示正在过站图标
  Stack showPassingRouteIcon() {
    List<Container> tempList = [];
    if (currentStationListIndex != null) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stationList.length - 1)) * currentStationListIndex!,
              0,
              0,
              0),
          child: CustomPaint(
              painter: StationIconSmallPainter(
                  lineColor: Util.hexToColor(CustomColors.passingStation),
                  lineVariantColor:
                      Util.hexToColor(CustomColors.passingStationVariant),
                  shadow: false))));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示站名
  Stack showStationName() {
    List<Positioned> tempList = [];
    if (stationList.isNotEmpty && currentStationListIndex != null) {
      print(currentStationListIndex);
      print(terminusListIndex);

      //选站时注意不要让当前站在终点站左边时，终点站为前四站；当前站在终点站右边时，终点站为末四站。（五站图怎么可能只显示四站！！！）懒得写异常抛出了，使用时自觉些
      //当前站在终点站左边
      if (currentStationListIndex! < terminusListIndex!) {
        //当前站为第3站~末3站
        if (currentStationListIndex! > 1 &&
            currentStationListIndex! < terminusListIndex! - 1) {
          int count = 0;
          for (int i = currentStationListIndex! - 2;
              i < currentStationListIndex! + 3;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
        //当前站为第1站
        else if (currentStationListIndex == 0) {
          int count = 0;
          for (int i = currentStationListIndex!;
              i < currentStationListIndex! + 5;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
        //当前站为第2站
        else if (currentStationListIndex == 1) {
          int count = 0;
          for (int i = currentStationListIndex! - 1;
              i < currentStationListIndex! + 4;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
      }
      //当前站在终点站右边
      else if (currentStationListIndex! > terminusListIndex!) {
        //当前站为第3站~末3站
        if (currentStationListIndex! > terminusListIndex! + 1 &&
            currentStationListIndex! < stationList.length - 2) {
          int count = 0;
          for (int i = currentStationListIndex! - 2;
              i < currentStationListIndex! + 3;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
        //当前站为末2站
        else if (currentStationListIndex == stationList.length - 2) {
          int count = 0;
          for (int i = currentStationListIndex! - 3;
              i < currentStationListIndex! + 2;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
        //当前站为末1站
        else if (currentStationListIndex == stationList.length - 1) {
          int count = 0;
          for (int i = currentStationListIndex! - 4;
              i < currentStationListIndex! + 1;
              i++) {
            tempList.add(Positioned(
              top: 229,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameCN,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            tempList.add(Positioned(
              top: 273,
              left: -916 + count * 446,
              right: 0,
              child: Center(
                child: Text(
                  stationList[i].stationNameEN,
                  style: const TextStyle(
                    fontSize: 15.5,
                    color: Colors.black,
                  ),
                ),
              ),
            ));
            count++;
          }
        }
      }
    }

    return Stack(
      children: tempList,
    );
  }

  //导入背景图片，图片样式复刻已完成，此功能此后只做开发用途
  void _importImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['png'],
      dialogTitle: '选择背景图片文件',
    );
    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  //导入线路文件
  @override
  void importLineJson() async {
    List<dynamic> stationsFromJson = [];
    Map<String, dynamic> jsonData;

    // 选择 JSON 文件
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: true,
        allowedExtensions: ['json'],
        dialogTitle: '选择线路 JSON 文件',
        lockParentWindow: true);
    if (result != null) {
      Uint8List bytes = result.files.single.bytes!;
      //尝试读取文件
      try {
        // 读取 JSON 文件内容
        String jsonString = utf8.decode(bytes);
        // 解析 JSON 数据，保存到键值对中
        jsonData = json.decode(jsonString);
        // 将站点保存到临时集合中
        stationsFromJson = jsonData['stations'];
        // 站点不能少于 2 或大于 32
        if (stationsFromJson.length >= 2 && stationsFromJson.length <= 32) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          currentStationListIndex = 0; //会导致显示的是前一个索引对应的站点
          terminusListIndex = 0;

          // 设置线路颜色和颜色变体
          lineNumber = jsonData['lineNumber'];
          lineNumberEN = jsonData['lineNumberEN'];
          lineColor = Util.hexToColor(jsonData['lineColor']);
          lineVariantColor = Util.hexToColor(jsonData['lineVariantColor']);
          // 遍历临时集合，获取站点信息，保存到 stations 集合中

          for (dynamic item in stationsFromJson) {
            Station station = Station(
              stationNameCN: item['stationNameCN'],
              stationNameEN: item['stationNameEN'],
            );
            stationList.add(station);
          }

          //文件成功导入后将下拉菜单默认值设为第一站
          currentStationListValue = stationList[0].stationNameCN;
          terminusListValue = stationList[0].stationNameCN;
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 5) {
          alertDialog("错误", "站点数量不能小于 5");
        } else if (stationsFromJson.length > 32) {
          alertDialog("错误", "直线型线路图站点数量不能大于 32，请使用 U 形线路图");
        }
      } catch (e) {
        print('读取文件失败: $e');
        alertDialog("错误", "选择的文件格式错误，或文件内容格式未遵循规范");
      }
    }
  }

  //导出全部图
  @override
  void exportAllImage() async {
    if (stationList.isNotEmpty) {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        if (currentStationListIndex! < terminusListIndex!) {
          for (int i = 0; i < terminusListIndex! + 1; i++) {
            currentStationListIndex = i;
            setState(() {});
            //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
            //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
            //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
            await exportImage(
                _passingImageKey,
                "$path\\已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
                false);
            await exportImage(
                _passingImageKey,
                "$path\\已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
                false);
            await exportImage(
                _mainImageKey,
                "$path\\五站图 已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                false);
          }
        } else if (currentStationListIndex! > terminusListIndex!) {
          for (int i = terminusListIndex!; i < stationList.length; i++) {
            currentStationListIndex = i;
            setState(() {});
            //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
            await exportImage(
                _passingImageKey,
                "$path\\已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}.png",
                false);
            await exportImage(
                _passingImageKey,
                "$path\\已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}.png",
                false);
            await exportImage(
                _mainImageKey,
                "$path\\五站图 已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                false);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
    } else {
      noStationsSnackbar();
    }
  }

  //导出当前站全部图
  Future<void> exportDynamicImage() async {
    if (stationList.isNotEmpty) {
      await exportMainImage();
      await exportPassingImage();
    } else {
      noStationsSnackbar();
    }
  }

  //导出主线路图
  Future<void> exportMainImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          _mainImageKey,
          await getExportPath(context, "保存",
              "运行中 ${currentStationListIndex! + 1} $currentStationListValue, $terminusListValue方向.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //导出下一站图
  Future<void> exportPassingImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          _passingImageKey,
          await getExportPath(context, "保存",
              "下一站 ${currentStationListIndex! + 1} $currentStationListValue.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //通用提示对话框方法
  void alertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("好"),
              )
            ],
          );
        });
  }

  //无线路信息 snackbar
  void noStationsSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("无线路信息"),
    ));
  }

  //通用导出方法
  @override
  Future<void> exportImage(
      GlobalKey key, String? path, bool showSnackbar) async {
    //路径检验有效，保存
    if (path != null) {
      try {
        //获取 key 对应的 stack 用于获取宽度
        RenderBox findRenderObject =
            key.currentContext!.findRenderObject() as RenderBox;

        //获取 key 对应的 stack 用于获取图片
        RenderRepaintBoundary boundary =
            key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(
            pixelRatio: exportWidthValue /
                findRenderObject
                    .size.width); //确保导出的图片宽高默认为2560*500，可通过下拉列表选择其他预设分辨率
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        File imgFile = File(path);
        await imgFile.writeAsBytes(pngBytes);
      } catch (e) {
        print('导出图片失败: $e');
      }
      if (showSnackbar) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
    }
  }
}
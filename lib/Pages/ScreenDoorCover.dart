// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/Object/Station.dart';
import 'package:main/Util/CustomRegExp.dart';
import '../../Object/Line.dart';
import '../../Parent/LCD.dart';
import '../../Util.dart';
import '../../Util/CustomColors.dart';
import '../../Util/CustomPainter.dart';
import '../../Util/Widgets.dart';

void loadFont() async {
  var fontLoader1 = FontLoader("GennokiokuLCDFont");
  fontLoader1
      .addFont(rootBundle.load('assets/font/FZLTHProGlobal-Regular.TTF'));
  var fontLoader2 = FontLoader("STZongyi");
  fontLoader2.addFont(rootBundle.load('assets/font/STZongyi.ttf'));
  await fontLoader1.load();
  await fontLoader2.load();
}

class ScreenDoorCoverRoot extends StatelessWidget {
  const ScreenDoorCoverRoot({super.key});

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
      home: ScreenDoorCover(),
    );
  }
}

class ScreenDoorCover extends StatefulWidget {
  @override
  ScreenDoorCoverState createState() => ScreenDoorCoverState();
}

class ScreenDoorCoverState extends State<ScreenDoorCover> with LCD {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 640;
  static const double routeImageWidth = 1920;
  static const double stationImageWidth = 1280;

  //用于识别组件的 key
  final GlobalKey routeUpImageKey = GlobalKey();
  final GlobalKey routeDownImageKey = GlobalKey();
  final GlobalKey stationImageKey = GlobalKey();
  final GlobalKey directionUpImageKey = GlobalKey();
  final GlobalKey directionDownImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //站名集合
  List<Station> stationList = [];

  //创建换乘线路列表的列表
  List<List<Line>> transferLineList = [];

  String lineNumber = "";
  String lineNumberEN = "";

  //线路颜色，默认透明，导入文件时赋值
  Color lineColor = Colors.transparent;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? currentStationListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? currentStationListIndex;

  //默认导出高度
  int exportHeightValue = 1280;

  //线路线条长宽
  int lineLength = 1700;
  static double lineHeight = 17;

  //用于计算站名图中线条所需宽度
  TextStyle stationNameTextTextStyle = TextStyle(
      fontSize: 118,
      letterSpacing: 4,
      fontFamily: "HYYanKaiW",
      color: Util.hexToColor(CustomColors.screenDoorCoverStationName));

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
                  },
                  value: currentStationListValue,
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: previousStation,
                    child: const Text(
                      "上一站",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: nextStation,
                    child: const Text(
                      "下一站",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: () {
                      setState(() {
                        if (stationList.isNotEmpty) {
                          stationList = stationList.reversed.toList();
                          transferLineList = transferLineList.reversed.toList();
                          currentStationListIndex = stationList.length -
                              1 -
                              currentStationListIndex!; //反转站点索引
                        }
                      });
                    },
                    child: const Text(
                      "反转站点",
                      style: TextStyle(color: Colors.black),
                    ),
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
                      //上行主线路图
                      RepaintBoundary(
                        key: routeUpImageKey,
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: routeImageWidth,
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
                              padding: const EdgeInsets.fromLTRB(72, 345, 0, 0),
                              child: showStationName(true),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(106, 278, 0, 0),
                              child: showRouteLine(true),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(75, 286, 0, 0),
                              child: showRouteIcon(true),
                            ),
                            Container(
                              width: routeImageWidth,
                              height: imageHeight,
                              child: showTransferIcon(true),
                            ),
                          ],
                        ),
                      ),
                      //下行主线路图
                      RepaintBoundary(
                        key: routeDownImageKey,
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: routeImageWidth,
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
                              padding: const EdgeInsets.fromLTRB(72, 345, 0, 0),
                              child: showStationName(false),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(106, 278, 0, 0),
                              child: showRouteLine(false),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(75, 286, 0, 0),
                              child: showRouteIcon(false),
                            ),
                            Container(
                              width: routeImageWidth,
                              height: imageHeight,
                              child: showTransferIcon(false),
                            ),
                          ],
                        ),
                      ),
                      //站名图
                      RepaintBoundary(
                        key: stationImageKey,
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: stationImageWidth,
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
                              padding: const EdgeInsets.fromLTRB(27, 32, 0, 0),
                              child: Transform.scale(
                                  alignment: Alignment.topLeft,
                                  scale: 2.4,
                                  child: Widgets.lineNumberIcon(
                                      lineColor, lineNumber, lineNumberEN)),
                            ),
                            Container(
                                height: imageHeight,
                                width: stationImageWidth,
                                child: Stack(
                                  children: [
                                    Positioned(
                                        left: 0,
                                        top: 158,
                                        right: 0,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          currentStationListIndex == null
                                              ? ""
                                              : stationList[
                                                      currentStationListIndex!]
                                                  .stationNameCN,
                                          //默认时索引为空，不显示站名；不为空时根据索引对应站名显示
                                          style: stationNameTextTextStyle,
                                        )),
                                    Positioned(
                                        left: 0,
                                        top: 300,
                                        right: 0,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          currentStationListIndex == null
                                              ? ""
                                              : stationList[
                                                      currentStationListIndex!]
                                                  .stationNameEN,
                                          style: TextStyle(
                                              fontSize: 43,
                                              letterSpacing: 2,
                                              color: Util.hexToColor(CustomColors
                                                  .screenDoorCoverStationName)),
                                        )),
                                  ],
                                )),
                            Container(
                                height: imageHeight,
                                width: stationImageWidth,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 278,
                                      left: 0,
                                      width: currentStationListIndex != null
                                          ? (stationImageWidth -
                                                      Util.getTextWidth(
                                                          stationList[
                                                                  currentStationListIndex!]
                                                              .stationNameCN,
                                                          stationNameTextTextStyle)) /
                                                  2 -
                                              110
                                          : 0,
                                      height: lineHeight,
                                      child: Container(
                                          decoration:
                                              BoxDecoration(color: lineColor)),
                                    ),
                                    Positioned(
                                      top: 278,
                                      right: 0,
                                      width: currentStationListIndex != null
                                          ? (stationImageWidth -
                                                      Util.getTextWidth(
                                                          stationList[
                                                                  currentStationListIndex!]
                                                              .stationNameCN,
                                                          stationNameTextTextStyle)) /
                                                  2 -
                                              110
                                          : 0,
                                      height: lineHeight,
                                      child: Container(
                                          decoration:
                                              BoxDecoration(color: lineColor)),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      //上行运行方向图
                      RepaintBoundary(
                        key: directionUpImageKey,
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: stationImageWidth,
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
                            directionImageTerminusLabel(true),
                            directionArrow(true),
                            directionImageLine(true),
                            directionImageNextStationLabel(true)
                          ],
                        ),
                      ),
                      //下行运行方向图
                      RepaintBoundary(
                        key: directionDownImageKey,
                        child: Stack(
                          children: [
                            const SizedBox(
                              width: stationImageWidth,
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
                            directionImageTerminusLabel(false),
                            directionArrow(false),
                            directionImageLine(false),
                            directionImageNextStationLabel(false)
                          ],
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
          transferLineList.clear();
          lineColor = Colors.transparent;
          currentStationListIndex = null;
          currentStationListValue = null;
          lineNumber = "";
          lineNumberEN = "";
          setState(() {});
        },
        tooltip: '重置',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  MenuBar importAndExportMenubar() {
    return MenuBar(children: [
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
      const VerticalDivider(thickness: 2),
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
      const VerticalDivider(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportRouteUpImage,
          child: const Text(
            "导出上行主线路图",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportRouteDownImage,
          child: const Text(
            "导出下行主线路图",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportStationImage,
          child: const Text(
            "导出站名图",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportDirectionUpImage,
          child: const Text(
            "导出上行运行方向图",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportDirectionDownImage,
          child: const Text(
            "导出下行运行方向图",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    ]);
  }

  //运行方向图的下一站标签
  Container directionImageNextStationLabel(bool isToLeft) {
    if (isToLeft) {
      //上行
      return currentStationListIndex != 0 && currentStationListIndex != null
          ? Container(
              height: imageHeight,
              width: stationImageWidth,
              child: Stack(
                children: [
                  Positioned(
                      left: 20,
                      top: 350,
                      child: Text(
                        "下一站    ${stationList[currentStationListIndex! - 1].stationNameCN}",
                        style: const TextStyle(fontSize: 40),
                      )),
                  Positioned(
                      left: 20,
                      top: 400,
                      right: 0,
                      child: Text(
                        "Next station  ${stationList[currentStationListIndex! - 1].stationNameEN}",
                        style: const TextStyle(fontSize: 26),
                      )),
                ],
              ),
            )
          : Container();
    } else {
      //下行
      return currentStationListIndex != stationList.length - 1 &&
              currentStationListIndex != null
          ? Container(
              height: imageHeight,
              width: stationImageWidth,
              child: Stack(
                children: [
                  Positioned(
                      left: 20,
                      top: 350,
                      child: Text(
                        "下一站    ${stationList[currentStationListIndex! + 1].stationNameCN}",
                        style: const TextStyle(fontSize: 40),
                      )),
                  Positioned(
                      left: 20,
                      top: 400,
                      right: 0,
                      child: Text(
                        "Next station  ${stationList[currentStationListIndex! + 1].stationNameEN}",
                        style: const TextStyle(fontSize: 26),
                      )),
                ],
              ),
            )
          : Container();
    }
  }

  //运行方向图线
  Container directionImageLine(bool isToLeft) {
    return Container(
        height: imageHeight,
        width: stationImageWidth,
        child: Stack(
          children: [
            Positioned(
              top: 278,
              left: 0,
              width: currentStationListIndex != null
                  ? (stationImageWidth -
                              Util.getTextWidth(
                                  isToLeft
                                      ? "往 ${stationList[0].stationNameCN}"
                                      : "往 ${stationList[stationList.length - 1].stationNameCN}",
                                  TextStyle(
                                      fontSize: 77,
                                      color: Util.hexToColor(CustomColors
                                          .screenDoorCoverStationName)))) /
                          2 -
                      130
                  : 0,
              height: lineHeight,
              child: Container(decoration: BoxDecoration(color: lineColor)),
            ),
            Positioned(
              top: 278,
              right: 0,
              width: currentStationListIndex != null
                  ? (stationImageWidth -
                              Util.getTextWidth(
                                  isToLeft
                                      ? "往 ${stationList[0].stationNameCN}"
                                      : "往 ${stationList[stationList.length - 1].stationNameCN}",
                                  TextStyle(
                                      fontSize: 77,
                                      color: Util.hexToColor(CustomColors
                                          .screenDoorCoverStationName)))) /
                          2 -
                      130
                  : 0,
              height: lineHeight,
              child: Container(decoration: BoxDecoration(color: lineColor)),
            ),
          ],
        ));
  }

  //终点站标签
  Container directionImageTerminusLabel(bool isToLeft) {
    String terminusTextCN = "";
    String terminusTextEN = "";
    double leftPos = 138; //默认左边距
    if (currentStationListIndex == null) {
      //默认情况下不显示终点站标签
      terminusTextCN = "";
      terminusTextEN = "";
    } else {
      if (isToLeft) {
        //上行
        if (currentStationListIndex == 0) {
          //当前站为第一站时显示终点站
          terminusTextCN = "终点站 ${stationList[0].stationNameCN}";
          terminusTextEN = "Terminus ${stationList[0].stationNameEN}";
          leftPos = 0;
        } else {
          //当前站不为第一站时显示往终点站
          terminusTextCN = "往 ${stationList[0].stationNameCN}";
          terminusTextEN = "To ${stationList[0].stationNameEN}";
        }
      } else {
        //下行
        if (currentStationListIndex == stationList.length - 1) {
          //当前站为终点站时显示终点站
          terminusTextCN =
              "终点站 ${stationList[stationList.length - 1].stationNameCN}";
          terminusTextEN =
              "Terminus ${stationList[stationList.length - 1].stationNameEN}";
          leftPos = 0;
        } else {
          //当前站不为终点站时显示往终点站
          terminusTextCN =
              "往 ${stationList[stationList.length - 1].stationNameCN}";
          terminusTextEN =
              "To ${stationList[stationList.length - 1].stationNameEN}";
        }
      }
    }
    return Container(
        height: imageHeight,
        width: stationImageWidth,
        child: Stack(
          children: [
            Positioned(
                left: leftPos,
                top: 200,
                right: 0,
                child: Text(
                  textAlign: TextAlign.center,
                  terminusTextCN,
                  style: TextStyle(
                      fontSize: 77,
                      color: Util.hexToColor(
                          CustomColors.screenDoorCoverStationName)),
                )),
            Positioned(
                left: leftPos,
                top: 305,
                right: 0,
                child: Text(
                  textAlign: TextAlign.center,
                  terminusTextEN,
                  style: TextStyle(
                      fontSize: 30,
                      letterSpacing: 2,
                      color: Util.hexToColor(
                          CustomColors.screenDoorCoverStationName)),
                )),
          ],
        ));
  }

  //方向箭头
  Positioned directionArrow(bool isToLeft) {
    if (currentStationListIndex == null) {
      return Positioned(child: Container());
    } else {
      if (isToLeft && currentStationListIndex == 0 ||
          !isToLeft && currentStationListIndex == stationList.length - 1) {
        //上行且当前站为第一站，或下行且当前站为终点站时不显示箭头
        return Positioned(child: Container());
      } else {
        return Positioned(
            left: -200 -
                (Util.getTextWidth(
                        isToLeft
                            ? "往 ${stationList[0].stationNameCN}"
                            : "往 ${stationList[stationList.length - 1].stationNameCN}",
                        TextStyle(
                            fontSize: 77,
                            color: Util.hexToColor(
                                CustomColors.screenDoorCoverStationName))) -
                    138),
            top: 242,
            right: 0,
            child: SvgPicture.string(
              Util.screenDoorCoverDirectionArrow,
              width: 90,
              height: 90,
            ));
      }
    }
  }

  //显示线路
  Stack showRouteLine(bool isToLeft) {
    List<Container> lineList = [];
    //显示整条线，默认为已过站
    for (int i = 0; i < stationList.length - 1; i++) {
      lineList.add(routeLine(
          i, Util.hexToColor(CustomColors.screenDoorCoverPassedStation)));
    }
    //根据选择的当前站和终点站，替换已过站为未过站
    if (currentStationListIndex != null) {
      //上行
      if (isToLeft) {
        List<Container> replaceList = [];
        for (int i = 0; i < currentStationListIndex!; i++) {
          replaceList.add(routeLine(i, lineColor));
        }
        lineList.replaceRange(0, currentStationListIndex!, replaceList);
      }
      //下行
      else {
        List<Container> replaceList = [];
        for (int i = 0;
            i < stationList.length - currentStationListIndex! - 1;
            i++) {
          replaceList.add(routeLine(i, lineColor));
        }
        lineList.replaceRange(
            0, stationList.length - currentStationListIndex! - 1, replaceList);
      }
    }
    return Stack(
      children: lineList,
    );
  }

  //线路
  Container routeLine(int i, Color color) {
    return Container(
        padding:
            EdgeInsets.only(left: (lineLength / (stationList.length - 1)) * i),
        child: ClipPath(
            clipper: ScreenDoorCoverRouteLineClipper(),
            child: Container(
              width: (lineLength / (stationList.length - 1)) - 42,
              //每个站与站之间线条的宽度
              height: lineHeight,
              color: color,
            )));
  }

  //显示站点图标  与 showRouteLine 类似
  Stack showRouteIcon(bool isToLeft) {
    List<Container> iconList = [];
    if (stationList.isNotEmpty) {
      for (int i = 0; i < stationList.length; i++) {
        iconList.add(Container(
            padding: EdgeInsets.fromLTRB(
                10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
            child: CustomPaint(
              painter: ScreenDoorCoverStationIconPainter(
                  Util.hexToColor(CustomColors.screenDoorCoverPassedStation)),
            )));
      }
      //上行
      if (isToLeft) {
        List<Container> replaceList = [];
        for (int i = 0; i < currentStationListIndex!; i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: ScreenDoorCoverStationIconPainter(lineColor),
              )));
        }
        iconList.replaceRange(0, currentStationListIndex!, replaceList);
      }
      //下行
      else {
        List<Container> replaceList = [];
        for (int i = 0;
            i < stationList.length - currentStationListIndex! - 1;
            i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: ScreenDoorCoverStationIconPainter(lineColor),
              )));
        }
        iconList.replaceRange(
            0, stationList.length - currentStationListIndex! - 1, replaceList);
      }
    }
    return Stack(
      children: iconList,
    );
  }

  //显示换乘线路图标
  Stack showTransferIcon(bool isToLeft) {
    List<Positioned> iconList = [];
    List<List<Line>> transferLineListToShow = [];
    //上行
    if (isToLeft) {
      transferLineListToShow = transferLineList;
    }
    //下行
    else {
      transferLineListToShow = transferLineList.reversed.toList();
    }

    //遍历获取每站的换乘信息列表
    for (int i = 0; i < transferLineList.length; i++) {
      List<Line> value = transferLineListToShow[i];
      if (value.isNotEmpty) {
        //遍历获取每站的换乘信息列表中具体的换乘线路信息
        for (int j = 0; j < value.length; j++) {
          Line transferLine = value[j];
          if (CustomRegExp.oneDigit.hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                top: -47 * j + 223,
                left: (lineLength / (stationList.length - 1)) * i + 68,
                child: Transform.scale(
                    scale: 1.24,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        //换乘线路图标
                        Widgets.transferLineTextOneDigit(transferLine),
                        //换乘线路数字
                      ],
                    ))));
          } else if (CustomRegExp.twoDigits
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                top: -47 * j + 223,
                left: (lineLength / (stationList.length - 1)) * i + 68,
                child: Transform.scale(
                    scale: 1.24,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextTwoDigits(transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.oneDigitOneCharacter
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                top: -47 * j + 223,
                left: (lineLength / (stationList.length - 1)) * i + 68,
                child: Transform.scale(
                    scale: 1.24,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextOneDigitOneCharacter(
                            transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.twoCharacters
              .hasMatch(transferLine.lineNumberEN)) {
            {
              iconList.add(Positioned(
                  top: -47 * j + 223,
                  left: (lineLength / (stationList.length - 1)) * i + 68,
                  child: Transform.scale(
                      scale: 1.24,
                      child: Stack(
                        children: [
                          Widgets.transferLineIcon(transferLine),
                          Widgets.transferLineTextTwoCharacters(transferLine),
                        ],
                      ))));
            }
          }
        }
      }
    }
    return Stack(
      children: iconList,
    );
  }

  //显示主线路图站名
  Stack showStationName(bool isToLeft) {
    List<Container> tempList = [];
    //上行
    if (isToLeft) {
      for (int i = 0; i < stationList.length; i++) {
        tempList.add(stationNameCN(
            i,
            Util.hexToColor(CustomColors.screenDoorCoverPassedStationText),
            stationList));
        tempList.add(stationNameEN(
            i,
            Util.hexToColor(CustomColors.screenDoorCoverPassedStationText),
            stationList));
      }
      //根据选择的当前站，替换已过站为未过站
      if (currentStationListIndex != null) {
        List<Container> replaceList = [];
        for (int i = 0; i < currentStationListIndex!; i++) {
          replaceList.add(stationNameCN(i, Colors.black, stationList));
          replaceList.add(stationNameEN(i, Colors.black, stationList));
        }
        tempList.replaceRange(0, 2 * currentStationListIndex!, replaceList);
      }
    }
    //下行
    else {
      List<Station> reversedStationList = stationList.reversed.toList();
      for (int i = 0; i < stationList.length; i++) {
        tempList.add(stationNameCN(
            i,
            Util.hexToColor(CustomColors.screenDoorCoverPassedStationText),
            reversedStationList));
        tempList.add(stationNameEN(
            i,
            Util.hexToColor(CustomColors.screenDoorCoverPassedStationText),
            reversedStationList));
      }
      //根据选择的当前站，替换已过站为未过站
      if (currentStationListIndex != null) {
        List<Container> replaceList = [];
        for (int i = 0;
            i < stationList.length - 1 - currentStationListIndex!;
            i++) {
          replaceList.add(stationNameCN(i, Colors.black, reversedStationList));
          replaceList.add(stationNameEN(i, Colors.black, reversedStationList));
        }
        tempList.replaceRange(
            0,
            2 * (stationList.length - 1 - currentStationListIndex!),
            replaceList);
      }
    }

    return Stack(
      children: tempList,
    );
  }

  //主线路图站名
  Container stationNameCN(int i, Color color, List<Station> stationList) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          13 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
      child: Container(
        //顺时针45度
        transform: Matrix4.rotationZ(0.75),
        child: Text(
          stationList[i].stationNameCN,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
      ),
    );
  }

  //主线路图站名
  Container stationNameEN(int i, Color color, List<Station> stationList) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          //英文站名做适当偏移
          (lineLength / (stationList.length - 1)) * i,
          15,
          0,
          0),
      child: Container(
        transform: Matrix4.rotationZ(0.75),
        child: Text(
          stationList[i].stationNameEN,
          style: TextStyle(
            //fontWeight: FontWeight.bold,
            fontSize: 12,
            color: color,
          ),
        ),
      ),
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
        // 站点不能少于 3 或大于 32
        if (stationsFromJson.length >= 3 && stationsFromJson.length <= 32) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          transferLineList.clear();
          currentStationListIndex = 0; //会导致显示的是前一个索引对应的站点

          // 设置线路颜色和颜色变体
          lineNumber = jsonData['lineNumber'];
          lineNumberEN = jsonData['lineNumberEN'];
          lineColor = Util.hexToColor(jsonData['lineColor']);
          // 遍历临时集合，获取站点信息，保存到 stations 集合中

          for (dynamic item in stationsFromJson) {
            //换乘信息和站点信息分开存，简化代码，显示换乘线路图标时直接读换乘线路列表的列表
            //创建换乘线路列表
            List<Line> transferLines = [];
            //判断是否有换乘信息
            if (item['transfer'] != null) {
              //读取换乘信息并转为换乘线路列表
              List<dynamic> transfers = item['transfer'];
              transferLines = transfers.map((transfer) {
                return Line("",
                    lineNumberEN: transfer['lineNumberEN'],
                    lineColor: transfer['lineColor']);
              }).toList();
            }
            //添加换乘信息列表到换乘信息列表的列表
            transferLineList.add(transferLines);

            Station station = Station(
              stationNameCN: item['stationNameCN'],
              stationNameEN: item['stationNameEN'],
            );
            stationList.add(station);
          }

          //文件成功导入后将下拉菜单默认值设为第一站
          currentStationListValue = stationList[0].stationNameCN;
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 2) {
          alertDialog("错误", "站点数量不能小于 2");
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
        for (int i = 0; i < stationList.length; i++) {
          currentStationListIndex = i;
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              routeUpImageKey,
              "$path\\屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向.png",
              false);
          await exportImage(
              routeUpImageKey,
              "$path\\屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向.png",
              false);
          await exportImage(
              routeDownImageKey,
              "$path\\屏蔽门盖板 下行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向.png",
              false);
          await exportImage(
              stationImageKey,
              "$path\\屏蔽门盖板 站名 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
              false);
          await exportImage(
              directionUpImageKey,
              "$path\\屏蔽门盖板 上行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向.png",
              false);
          await exportImage(
              directionDownImageKey,
              "$path\\屏蔽门盖板 下行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向.png",
              false);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
    } else {
      noStationsSnackbar();
    }
  }

  //导出上行主线路图
  Future<void> exportRouteUpImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          routeUpImageKey,
          await getExportPath(context, "保存",
              "屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //导出下行主线路图
  Future<void> exportRouteDownImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          routeUpImageKey,
          await getExportPath(context, "保存",
              "屏蔽门盖板 下行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //导出站名图
  Future<void> exportStationImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          stationImageKey,
          await getExportPath(context, "保存",
              "屏蔽门盖板 站名 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //导出上行运行方向图
  Future<void> exportDirectionUpImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          directionUpImageKey,
          await getExportPath(context, "保存",
              "屏蔽门盖板 上行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向.png"),
          true);
    } else {
      noStationsSnackbar();
    }
  }

  //导出下行运行方向图
  Future<void> exportDirectionDownImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          directionDownImageKey,
          await getExportPath(context, "保存",
              "屏蔽门盖板 下行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向.png"),
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
            pixelRatio: exportHeightValue /
                findRenderObject.size.height); //确保导出的图片高度为1280
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

  void nextStation() {
    if (currentStationListIndex == stationList.length - 1 ||
        currentStationListIndex == null) {
      return;
    } else {
      setState(() {
        currentStationListIndex = currentStationListIndex! + 1;
        currentStationListValue =
            stationList[currentStationListIndex!].stationNameCN;
      });
    }
  }

  void previousStation() {
    if (currentStationListIndex == 0 || currentStationListIndex == null) {
      return;
    } else {
      setState(() {
        currentStationListIndex = currentStationListIndex! - 1;
        currentStationListValue =
            stationList[currentStationListIndex!].stationNameCN;
      });
    }
  }
}

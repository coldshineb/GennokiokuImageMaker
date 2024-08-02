// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/Object/Station.dart';
import 'package:main/Util/CustomRegExp.dart';
import '../../../Object/Line.dart';
import '../../Parent/ImageMaker/ImageMaker.dart';
import '../../../Util.dart';
import '../../../Util/CustomColors.dart';
import '../../../Util/CustomPainter.dart';
import '../../../Util/Widgets.dart';
import '../../Preference.dart';

class ScreenDoorCoverRoot extends StatelessWidget {
  const ScreenDoorCoverRoot({super.key});

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
      home: const ScreenDoorCover(),
    );
  }
}

class ScreenDoorCover extends StatefulWidget {
  const ScreenDoorCover({super.key});

  @override
  ScreenDoorCoverState createState() => ScreenDoorCoverState();
}

class ScreenDoorCoverState extends State<ScreenDoorCover> with ImageMaker {
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

  bool useStationNameAsBatchExportFolderName = true; //是否使用站名作为批量导出子文件夹名
  int openSide = 0; //是否左侧开门

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
      color: Util.hexToColor(
          CustomColors.railwayTransitScreenDoorCoverStationName));

  //设置项
  late bool generalIsDevMode;
  late bool generalIsScaleEnabled;
  late int railwayTransitScreenDoorCoverMaxStation;

  //获取设置项
  void getSetting() {
    generalIsDevMode = Preference.generalIsDevMode;
    generalIsScaleEnabled = Preference.generalIsScaleEnabled;
    railwayTransitScreenDoorCoverMaxStation =
        Util.railwayTransitScreenDoorCoverMaxStation;
  }

  @override
  Widget build(BuildContext context) {
    getSetting();
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
                  child: const Text("当前站"),
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
                    child: const Text("上一站"),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: nextStation,
                    child: const Text("下一站"),
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
                    child: const Text("反转站点"),
                  ),
                ),
              ]),
              MenuBar(style: menuStyle(context), children: [
                Container(
                  padding: const EdgeInsets.only(top: 14, left: 7),
                  child: const Text("开门方向"),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                      value: 0,
                      groupValue: openSide,
                      onChanged: (v) {
                        setState(() {
                          openSide = v!;
                        });
                      },
                      child: const Text("左侧开门")),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                      value: 1,
                      groupValue: openSide,
                      onChanged: (v) {
                        setState(() {
                          openSide = v!;
                        });
                      },
                      child: const Text("右侧开门")),
                )
              ])
            ],
          ),
          Expanded(
            child: generalIsScaleEnabled
                ? InteractiveViewer(
                    minScale: 1,
                    maxScale: Util.maxScale,
                    constrained: false,
                    child: body(),
                  )
                : body(),
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
              )),
          FloatingActionButton(
            onPressed: () {
              setState(() {});
            },
            tooltip: '刷新设置',
            child: const Icon(Icons.settings_backup_restore),
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
                    padding: const EdgeInsets.fromLTRB(106, 278, 0, 0),
                    child: showRouteLine(true),
                  ),
                  routeLineLeft(),
                  routeLineRight(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(75, 286.5, 0, 0),
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
                    padding: const EdgeInsets.fromLTRB(106, 278, 0, 0),
                    child: showRouteLine(false),
                  ),
                  routeLineLeft(),
                  routeLineRight(),
                  Container(
                    padding: const EdgeInsets.fromLTRB(75, 286.5, 0, 0),
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
                                    : stationList[currentStationListIndex!]
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
                                    : stationList[currentStationListIndex!]
                                        .stationNameEN,
                                style: TextStyle(
                                    fontSize: 43,
                                    letterSpacing: 2,
                                    color: Util.hexToColor(CustomColors
                                        .railwayTransitScreenDoorCoverStationName)),
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
                                decoration: BoxDecoration(color: lineColor)),
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
                                decoration: BoxDecoration(color: lineColor)),
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
        ),
      ),
    );
  }

  //左侧顶头线条
  Container routeLineLeft() {
    return Container(
        height: imageHeight,
        width: routeImageWidth,
        child: Stack(
          children: [
            stationList.isNotEmpty
                ? Positioned(
                    top: 278,
                    left: 14,
                    child: ClipPath(
                        clipper: ScreenDoorCoverRouteLineClipper(),
                        child: Container(
                          width: 50,
                          //每个站与站之间线条的宽度
                          height: lineHeight,
                          color: openSide == 0
                              ? lineColor
                              : Util.hexToColor(CustomColors
                                  .railwayTransitScreenDoorCoverPassedStation),
                        )))
                : Container(),
            stationList.isNotEmpty
                ? Positioned(
                    top: 278,
                    child: Container(
                      width: 50,
                      //每个站与站之间线条的宽度
                      height: lineHeight,
                      color: openSide == 0
                          ? lineColor
                          : Util.hexToColor(CustomColors
                              .railwayTransitScreenDoorCoverPassedStation),
                    ))
                : Container(),
          ],
        ));
  }

  //右侧顶头线条
  Container routeLineRight() {
    return Container(
        height: imageHeight,
        width: routeImageWidth,
        child: Stack(
          children: [
            stationList.isNotEmpty
                ? Positioned(
                    top: 278,
                    right: 64,
                    child: ClipPath(
                        clipper: ScreenDoorCoverRouteLineClipper(),
                        child: Container(
                          width: 50,
                          //每个站与站之间线条的宽度
                          height: lineHeight,
                          color: openSide == 1
                              ? lineColor
                              : Util.hexToColor(CustomColors
                                  .railwayTransitScreenDoorCoverPassedStation),
                        )))
                : Container(),
            stationList.isNotEmpty
                ? Positioned(
                    top: 278,
                    right: 0,
                    child: Container(
                      width: 80,
                      //每个站与站之间线条的宽度
                      height: lineHeight,
                      color: openSide == 1
                          ? lineColor
                          : Util.hexToColor(CustomColors
                              .railwayTransitScreenDoorCoverPassedStation),
                    ))
                : Container(),
          ],
        ));
  }

  @override
  MenuBar importAndExportMenubar() {
    return MenuBar(style: menuStyle(context), children: [
      generalIsDevMode
          ? Container(
              height: 48,
              child: MenuItemButton(
                onPressed: _importImage,
                child: const Text("导入图片"),
              ),
            )
          : Container(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: importLineJson,
          child: const Text("导入线路"),
        ),
      ),
      const VerticalDivider(thickness: 2),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportAllImage,
          child: const Text("导出全部图"),
        ),
      ),
      Container(
          height: 48,
          child: CheckboxMenuButton(
            value: useStationNameAsBatchExportFolderName,
            onChanged: (bool? value) {
              useStationNameAsBatchExportFolderName = value!;
              setState(() {});
            },
            child: const Text("使用站名作为导出子文件夹名"),
          )),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportThisStationImage,
          child: const Text("导出当前站全部图"),
        ),
      ),
      const VerticalDivider(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportRouteUpImage,
          child: const Text("导出上行主线路图"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportRouteDownImage,
          child: const Text("导出下行主线路图"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportStationImage,
          child: const Text("导出站名图"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportDirectionUpImage,
          child: const Text("导出上行运行方向图"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportDirectionDownImage,
          child: const Text("导出下行运行方向图"),
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
                        style:
                            const TextStyle(fontSize: 40, color: Colors.black),
                      )),
                  Positioned(
                      left: 20,
                      top: 400,
                      right: 0,
                      child: Text(
                        "Next station  ${stationList[currentStationListIndex! - 1].stationNameEN}",
                        style:
                            const TextStyle(fontSize: 26, color: Colors.black),
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
                        style:
                            const TextStyle(fontSize: 40, color: Colors.black),
                      )),
                  Positioned(
                      left: 20,
                      top: 400,
                      right: 0,
                      child: Text(
                        "Next station  ${stationList[currentStationListIndex! + 1].stationNameEN}",
                        style:
                            const TextStyle(fontSize: 26, color: Colors.black),
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
                                          .railwayTransitScreenDoorCoverStationName)))) /
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
                                          .railwayTransitScreenDoorCoverStationName)))) /
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
    }
    if (currentStationListIndex != null) {
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
    if (openSide == 0) {
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
                        color: Util.hexToColor(CustomColors
                            .railwayTransitScreenDoorCoverStationName)),
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
                        color: Util.hexToColor(CustomColors
                            .railwayTransitScreenDoorCoverStationName)),
                  )),
            ],
          ));
    } else {
      return Container(
          height: imageHeight,
          width: stationImageWidth,
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  top: 200,
                  right: leftPos,
                  child: Text(
                    textAlign: TextAlign.center,
                    terminusTextCN,
                    style: TextStyle(
                        fontSize: 77,
                        color: Util.hexToColor(CustomColors
                            .railwayTransitScreenDoorCoverStationName)),
                  )),
              Positioned(
                  left: 0,
                  top: 305,
                  right: leftPos,
                  child: Text(
                    textAlign: TextAlign.center,
                    terminusTextEN,
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 2,
                        color: Util.hexToColor(CustomColors
                            .railwayTransitScreenDoorCoverStationName)),
                  )),
            ],
          ));
    }
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
        if (openSide == 0) {
          return Positioned(
              left: -200 -
                  (Util.getTextWidth(
                          isToLeft
                              ? "往 ${stationList[0].stationNameCN}"
                              : "往 ${stationList[stationList.length - 1].stationNameCN}",
                          TextStyle(
                              fontSize: 77,
                              color: Util.hexToColor(CustomColors
                                  .railwayTransitScreenDoorCoverStationName))) -
                      138),
              top: 242,
              right: 0,
              child: SvgPicture.string(
                Util.screenDoorCoverDirectionArrow,
                width: 90,
                height: 90,
              ));
        } else {
          return Positioned(
              right: -200 -
                  (Util.getTextWidth(
                          isToLeft
                              ? "往 ${stationList[0].stationNameCN}"
                              : "往 ${stationList[stationList.length - 1].stationNameCN}",
                          TextStyle(
                              fontSize: 77,
                              color: Util.hexToColor(CustomColors
                                  .railwayTransitScreenDoorCoverStationName))) -
                      138),
              top: 242,
              left: 0,
              child: Transform.rotate(
                angle: pi,
                child: SvgPicture.string(
                  Util.screenDoorCoverDirectionArrow,
                  width: 90,
                  height: 90,
                ),
              ));
        }
      }
    }
  }

  //显示线路
  Stack showRouteLine(bool isToLeft) {
    List<Container> lineList = [];
    //显示整条线，默认为已过站
    for (int i = 0; i < stationList.length - 1; i++) {
      lineList.add(routeLine(
          i,
          Util.hexToColor(
              CustomColors.railwayTransitScreenDoorCoverPassedStation)));
    }
    //根据选择的当前站和终点站，替换已过站为未过站
    if (currentStationListIndex != null) {
      //上行
      if (isToLeft) {
        if (openSide == 0) {
          List<Container> replaceList = [];
          for (int i = 0; i < currentStationListIndex!; i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(0, currentStationListIndex!, replaceList);
        } else {
          List<Container> replaceList = [];
          for (int i = stationList.length - 1 - currentStationListIndex!;
              i < stationList.length - 1;
              i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(
              stationList.length - 1 - currentStationListIndex!,
              stationList.length - 1,
              replaceList);
        }
      }
      //下行
      else {
        if (openSide == 0) {
          List<Container> replaceList = [];
          for (int i = 0;
              i < stationList.length - currentStationListIndex! - 1;
              i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(0,
              stationList.length - currentStationListIndex! - 1, replaceList);
        } else {
          List<Container> replaceList = [];
          for (int i = currentStationListIndex!;
              i < stationList.length - 1;
              i++) {
            replaceList.add(routeLine(i, lineColor));
          }
          lineList.replaceRange(
              currentStationListIndex!, stationList.length - 1, replaceList);
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
              painter: ScreenDoorCoverStationIconPainter(Util.hexToColor(
                  CustomColors.railwayTransitScreenDoorCoverPassedStation)),
            )));
      }
      //上行
      if (isToLeft) {
        if (openSide == 0) {
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
        } else {
          List<Container> replaceList = [];
          for (int i = stationList.length - currentStationListIndex!;
              i < stationList.length;
              i++) {
            replaceList.add(Container(
                padding: EdgeInsets.fromLTRB(
                    10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
                child: CustomPaint(
                  painter: ScreenDoorCoverStationIconPainter(lineColor),
                )));
          }
          iconList.replaceRange(stationList.length - currentStationListIndex!,
              stationList.length, replaceList);
        }
      }
      //下行
      else {
        if (openSide == 0) {
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
          iconList.replaceRange(0,
              stationList.length - currentStationListIndex! - 1, replaceList);
        } else {
          List<Container> replaceList = [];
          for (int i = currentStationListIndex! + 1;
              i < stationList.length;
              i++) {
            replaceList.add(Container(
                padding: EdgeInsets.fromLTRB(
                    10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
                child: CustomPaint(
                  painter: ScreenDoorCoverStationIconPainter(lineColor),
                )));
          }
          iconList.replaceRange(
              currentStationListIndex! + 1, stationList.length, replaceList);
        }
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
    if ((isToLeft && openSide == 0) || (!isToLeft && openSide == 1)) {
      transferLineListToShow = transferLineList;
    } else {
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
                top: -47 * j + 223.5,
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
                top: -47 * j + 223.5,
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
                top: -47 * j + 223.5,
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
                  top: -47 * j + 223.5,
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
            Util.hexToColor(
                CustomColors.railwayTransitScreenDoorCoverPassedStationText),
            openSide == 0 ? stationList : stationList.reversed.toList()));
        tempList.add(stationNameEN(
            i,
            Util.hexToColor(
                CustomColors.railwayTransitScreenDoorCoverPassedStationText),
            openSide == 0 ? stationList : stationList.reversed.toList()));
      }
      //根据选择的当前站，替换已过站为未过站
      if (currentStationListIndex != null) {
        if (openSide == 0) {
          List<Container> replaceList = [];
          for (int i = 0; i < currentStationListIndex!; i++) {
            replaceList.add(stationNameCN(i, Colors.black, stationList));
            replaceList.add(stationNameEN(i, Colors.black, stationList));
          }
          tempList.replaceRange(0, 2 * currentStationListIndex!, replaceList);
        } else {
          List<Station> reversedStationList = stationList.reversed.toList();
          List<Container> replaceList = [];
          for (int i = stationList.length - currentStationListIndex!;
              i < stationList.length;
              i++) {
            replaceList
                .add(stationNameCN(i, Colors.black, reversedStationList));
            replaceList
                .add(stationNameEN(i, Colors.black, reversedStationList));
          }
          tempList.replaceRange(
              2 * (stationList.length - currentStationListIndex!),
              2 * (stationList.length),
              replaceList);
        }
      }
    }
    //下行
    else {
      List<Station> reversedStationList = stationList.reversed.toList();
      for (int i = 0; i < stationList.length; i++) {
        tempList.add(stationNameCN(
            i,
            Util.hexToColor(
                CustomColors.railwayTransitScreenDoorCoverPassedStationText),
            openSide == 0 ? reversedStationList : stationList));
        tempList.add(stationNameEN(
            i,
            Util.hexToColor(
                CustomColors.railwayTransitScreenDoorCoverPassedStationText),
            openSide == 0 ? reversedStationList : stationList));
      }
      //根据选择的当前站，替换已过站为未过站
      if (currentStationListIndex != null) {
        if (openSide == 0) {
          List<Container> replaceList = [];
          for (int i = 0;
              i < stationList.length - 1 - currentStationListIndex!;
              i++) {
            replaceList
                .add(stationNameCN(i, Colors.black, reversedStationList));
            replaceList
                .add(stationNameEN(i, Colors.black, reversedStationList));
          }
          tempList.replaceRange(
              0,
              2 * (stationList.length - 1 - currentStationListIndex!),
              replaceList);
        } else {
          List<Container> replaceList = [];
          for (int i = currentStationListIndex! + 1;
              i < stationList.length;
              i++) {
            replaceList.add(stationNameCN(i, Colors.black, stationList));
            replaceList.add(stationNameEN(i, Colors.black, stationList));
          }
          tempList.replaceRange(2 * (currentStationListIndex! + 1),
              2 * (stationList.length), replaceList);
        }
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
            fontWeight: Util.railwayTransitScreenDoorCoverIsBoldFont,
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
            fontWeight: Util.railwayTransitScreenDoorCoverIsBoldFont,
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
        // 站点不能少于 3 或大于 maxStation
        if (stationsFromJson.length >= 3 &&
            stationsFromJson.length <=
                railwayTransitScreenDoorCoverMaxStation) {
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
        } else if (stationsFromJson.length < 3) {
          alertDialog(context, "错误", "站点数量不能小于 3");
        } else if (stationsFromJson.length >
            railwayTransitScreenDoorCoverMaxStation) {
          alertDialog(context, "错误",
              "站点数量不能大于 ${railwayTransitScreenDoorCoverMaxStation}，过多的站点会导致显示不美观或显示异常");
        }
      } catch (e) {
        print('读取文件失败: $e');
        alertDialog(context, "错误", "选择的文件格式错误，或文件内容格式未遵循规范");
      }
    }
  }

  //导出全部图
  void exportAllImage() async {
    if (stationList.isNotEmpty) {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        for (int i = 0; i < stationList.length; i++) {
          currentStationListIndex = i;
          useStationNameAsBatchExportFolderName
              ? Directory(
                      "$path${Util.pathSlash}${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}")
                  .create()
              : null;
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              context,
              stationList,
              routeUpImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png",
              true,
              exportHeightValue: exportHeightValue);
          await exportImage(
              context,
              stationList,
              routeUpImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png",
              true,
              exportHeightValue: exportHeightValue);
          await exportImage(
              context,
              stationList,
              routeDownImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 下行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png",
              true,
              exportHeightValue: exportHeightValue);
          await exportImage(
              context,
              stationList,
              stationImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 站名 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
              true,
              exportHeightValue: exportHeightValue);
          await exportImage(
              context,
              stationList,
              directionUpImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 上行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png",
              true,
              exportHeightValue: exportHeightValue);
          await exportImage(
              context,
              stationList,
              directionDownImageKey,
              "$path${Util.pathSlash}${useStationNameAsBatchExportFolderName ? "${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}${Util.pathSlash}" : ""}屏蔽门盖板 下行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png",
              true,
              exportHeightValue: exportHeightValue);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出当前站全部图
  Future<void> exportThisStationImage() async {
    if (stationList.isNotEmpty) {
      await exportRouteUpImage();
      await exportRouteDownImage();
      await exportStationImage();
      await exportDirectionUpImage();
      await exportDirectionDownImage();
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出上行主线路图
  Future<void> exportRouteUpImage() async {
    String fileName =
        "屏蔽门盖板 上行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png";
    await exportImage(context, stationList, routeUpImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }

  //导出下行主线路图
  Future<void> exportRouteDownImage() async {
    String fileName =
        "屏蔽门盖板 下行线路图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png";
    await exportImage(context, stationList, routeDownImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }

  //导出站名图
  Future<void> exportStationImage() async {
    String fileName =
        "屏蔽门盖板 站名 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png";
    await exportImage(context, stationList, stationImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }

  //导出上行运行方向图
  Future<void> exportDirectionUpImage() async {
    String fileName =
        "屏蔽门盖板 上行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[0].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png";
    await exportImage(
        context, stationList, directionUpImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }

  //导出下行运行方向图
  Future<void> exportDirectionDownImage() async {
    String fileName =
        "屏蔽门盖板 下行运行方向图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, ${stationList[stationList.length - 1].stationNameCN}方向 ${openSide == 0 ? "左侧" : "右侧"}.png";
    await exportImage(
        context, stationList, directionDownImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }

  //显示下一站、当前站和终点站下拉菜单内容
  List<DropdownMenuItem> showStationList(List<Station> stationList) {
    List<DropdownMenuItem> tempList = [];
    try {
      for (Station value in stationList) {
        tempList.add(DropdownMenuItem(
          value: value.stationNameCN,
          child: Text(value.stationNameCN),
        ));
      }
    } on Exception catch (e) {
      print(e);
    }
    return tempList;
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

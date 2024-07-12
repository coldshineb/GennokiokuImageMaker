// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/Station.dart';
import 'package:main/Util/CustomRegExp.dart';
import '../../../Object/Line.dart';
import '../../../Parent/RailwayTransit/LCD.dart';
import '../../../Preference.dart';
import '../../../Util.dart';
import '../../../Util/CustomColors.dart';
import '../../../Util/CustomPainter.dart';
import '../../../Util/Widgets.dart';
import '../../../main.dart';

class ArrivalLinearRouteRoot extends StatelessWidget {
  const ArrivalLinearRouteRoot({super.key});

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
      home: const ArrivalLinearRoute(),
    );
  }
}

class ArrivalLinearRoute extends StatefulWidget {
  const ArrivalLinearRoute({super.key});

  @override
  ArrivalLinearRouteState createState() => ArrivalLinearRouteState();
}

class ArrivalLinearRouteState extends State<ArrivalLinearRoute> with LCD {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 335;
  static const double imageWidth = 1715.2;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //背景纹理
  Uint8List? pattern;

  //站名集合
  List<Station> stationList = [];

  //创建换乘线路列表的列表
  List<List<Line>> transferLineList = [];

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

  //是否显示原忆轨道交通品牌图标
  bool showLogo = true;

  //默认导出宽度
  int exportWidthValue = 2560;

  //线路线条宽度
  int lineLength = 1470;

  //设置项
  late bool generalIsDevMode;
  late bool generalIsScaleEnabled;
  late bool railwayTransitLcdIsRouteColorSameAsLineColor;

  //获取设置项
  void getSetting() {
    generalIsDevMode = Preference.generalIsDevMode;
    generalIsScaleEnabled = Preference.generalIsScaleEnabled;
    railwayTransitLcdIsRouteColorSameAsLineColor = HomeState.sharedPreferences
            ?.getBool(
                PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor) ??
        DefaultPreference.railwayTransitLcdIsRouteColorSameAsLineColor;
  }

  @override
  Widget build(BuildContext context) {
    //loadFont();
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
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text("终点站"),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "终点站",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  items: showStationList(stationList),
                  onChanged: (value) {
                    try {
                      terminusListIndex = stationList.indexWhere(
                          (element) => element.stationNameCN == value);
                      terminusListValue = value;
                      setState(() {});
                    } catch (e) {
                      print(e);
                    }
                  },
                  value: terminusListValue,
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
                          terminusListIndex = stationList.length -
                              1 -
                              terminusListIndex!; //反转站点索引
                        }
                      });
                    },
                    child: const Text("反转站点"),
                  ),
                ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: FloatingActionButton(
                    onPressed: () {
                      //重置所有变量
                      _imageBytes = null;
                      pattern = null;
                      stationList.clear();
                      transferLineList.clear();
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
                  )),
              Container(
                  padding: const EdgeInsets.only(right: 15, bottom: 15),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {});
                    },
                    tooltip: '刷新设置',
                    child: const Icon(Icons.settings_backup_restore),
                  ))
            ],
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
              //主线路图
              RepaintBoundary(
                key: _mainImageKey,
                child: Container(
                  color: Util.hexToColor(CustomColors.backgroundColorLCD),
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
                      backgroundPattern(),
                      gennokiokuRailwayTransitLogoWidget(showLogo),
                      lineNumberIconWidget(lineColor, lineNumber, lineNumberEN),
                      Container(
                          padding: const EdgeInsets.fromLTRB(452.5, 8, 0, 0),
                          child: Text(
                            "当前站",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(446.5, 41, 0, 0),
                          child: Text(
                            "Current station",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(1111.5, 8, 0, 0),
                          child: Text(
                            "终点站",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(1124.5, 41, 0, 0),
                          child: Text(
                            "Terminus",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(549, 8, 0, 0),
                          child: Text(
                            currentStationListIndex == null
                                ? ""
                                : stationList[currentStationListIndex!]
                                    .stationNameCN,
                            //默认时索引为空，不显示站名；不为空时根据索引对应站名显示
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(1210.5, 8, 0, 0),
                          child: Text(
                            terminusListIndex == null
                                ? ""
                                : stationList[terminusListIndex!].stationNameCN,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(549.5, 41, 0, 0),
                          child: Text(
                            currentStationListIndex == null
                                ? ""
                                : stationList[currentStationListIndex!]
                                    .stationNameEN,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                          padding: const EdgeInsets.fromLTRB(1210.5, 41, 0, 0),
                          child: Text(
                            terminusListIndex == null
                                ? ""
                                : stationList[terminusListIndex!].stationNameEN,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: Util.railwayTransitLcdIsBoldFont,
                                color: Colors.black),
                          )),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 165, 0, 0),
                        child: showStationName(),
                      ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        padding: const EdgeInsets.fromLTRB(43, 221.5, 0, 0),
                        child: showTransferIcon(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(60, 195, 0, 0),
                        child: showRouteLine(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 202.5, 0, 0),
                        child: showRouteIcon(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Container backgroundPattern() {
    return pattern != null
        ? Container(
            height: imageHeight,
            width: imageWidth,
            child: Image.memory(pattern!, repeat: ImageRepeat.repeat))
        : Container();
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
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: importPattern,
          child: const Text("导入纹理"),
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
      const VerticalDivider(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportMainImage,
          child: const Text("导出主线路图"),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 14),
        child: const Text("导出分辨率"),
      ),
      DropdownButton(
        items: LCD.resolutionList(),
        onChanged: (value) {
          setState(() {
            exportWidthValue = value!;
          });
        },
        value: exportWidthValue,
      ),
      const VerticalDivider(thickness: 2),
      Container(
          height: 48,
          child: CheckboxMenuButton(
            value: showLogo,
            onChanged: (bool? value) {
              showLogo = value!;
              setState(() {});
            },
            child: const Text("显示品牌图标"),
          )),
    ]);
  }

  //显示线路
  Stack showRouteLine() {
    List<Container> lineList = [];
    Color routeLineColor =
        railwayTransitLcdIsRouteColorSameAsLineColor ? lineColor : Colors.green;
    //显示整条线，默认为已过站
    for (int i = 0; i < stationList.length - 1; i++) {
      lineList.add(
          (routeLine(i, Util.hexToColor(CustomColors.passedStationVariant))));
    }
    //根据选择的当前站和终点站，替换已过站为未过站
    if (currentStationListIndex != null && terminusListIndex != null) {
      List<Container> replaceList = [];
      //非空判断
      //当前站在终点站左侧
      if (currentStationListIndex! < terminusListIndex!) {
        //当前站不为起始站
        if (currentStationListIndex != 0) {
          for (int i = currentStationListIndex!; i < terminusListIndex!; i++) {
            //nextStationListIndex-1：当前站前的线条
            replaceList.add(routeLine(i, routeLineColor));
          }
          //替换原集合
          lineList.replaceRange(
              currentStationListIndex!, terminusListIndex!, replaceList);
        } else
        //当前站为起始站
        {
          for (int i = currentStationListIndex!; i < terminusListIndex!; i++) {
            replaceList.add(routeLine(i, routeLineColor));
          }
          lineList.replaceRange(
              currentStationListIndex!, terminusListIndex!, replaceList);
        }
      }
      //当前站在终点站右侧
      else if (currentStationListIndex! > terminusListIndex!) {
        //当前站不为终点站
        if (currentStationListIndex != stationList.length - 1) {
          for (int i = terminusListIndex!; i < currentStationListIndex!; i++) {
            replaceList.add(routeLine(i, routeLineColor));
          }
          lineList.replaceRange(
              terminusListIndex!, currentStationListIndex!, replaceList);
        } else
        //当前站为终点站
        {
          for (int i = terminusListIndex!; i < currentStationListIndex!; i++) {
            replaceList.add(routeLine(i, routeLineColor));
          }
          lineList.replaceRange(
              terminusListIndex!, currentStationListIndex!, replaceList);
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
      //间隔
      height: 15,
      child: Container(
        width: (lineLength / (stationList.length - 1)), //每个站与站之间线条的宽度
        color: color,
      ),
    );
  }

  //显示站点图标  与 showRouteLine 类似
  Stack showRouteIcon() {
    List<Container> iconList = [];
    Color routeIconColor =
        railwayTransitLcdIsRouteColorSameAsLineColor ? lineColor : Colors.green;
    Color? routeIconVariantColor = railwayTransitLcdIsRouteColorSameAsLineColor
        ? lineVariantColor
        : Colors.green[300];
    for (int i = 0; i < stationList.length; i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: LCDStationIconSmallPainter(
                lineColor: Util.hexToColor(CustomColors.passedStation),
                lineVariantColor:
                    Util.hexToColor(CustomColors.passedStationVariant),
                shadow: true),
          )));
    }
    if (currentStationListIndex != null && terminusListIndex != null) {
      if (currentStationListIndex! <= terminusListIndex!) {
        List<Container> replaceList = [];
        for (int i = currentStationListIndex! + 1;
            i < terminusListIndex! + 1;
            i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: LCDStationIconSmallPainter(
                    lineColor: routeIconColor,
                    lineVariantColor: routeIconVariantColor,
                    shadow: true),
              )));
        }
        iconList.replaceRange(
            currentStationListIndex! + 1, terminusListIndex! + 1, replaceList);
      } else if (currentStationListIndex! > terminusListIndex!) {
        List<Container> replaceList = [];
        for (int i = terminusListIndex!; i < currentStationListIndex!; i++) {
          replaceList.add(Container(
              padding: EdgeInsets.fromLTRB(
                  10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
              child: CustomPaint(
                painter: LCDStationIconSmallPainter(
                    lineColor: routeIconColor,
                    lineVariantColor: routeIconVariantColor,
                    shadow: true),
              )));
        }
        iconList.replaceRange(
            terminusListIndex!, currentStationListIndex!, replaceList);
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
              10 +
                  (lineLength / (stationList.length - 1)) *
                      currentStationListIndex!,
              0,
              0,
              0),
          child: CustomPaint(
              painter: LCDStationIconSmallPainter(
                  lineColor: Util.hexToColor(CustomColors.passingStation),
                  lineVariantColor:
                      Util.hexToColor(CustomColors.passingStationVariant),
                  shadow: false))));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示换乘线路图标
  Stack showTransferIcon() {
    List<Positioned> iconList = [];

    //遍历获取每站的换乘信息列表
    for (int i = 0; i < transferLineList.length; i++) {
      List<Line> value = transferLineList[i];
      if (value.isNotEmpty) {
        //遍历获取每站的换乘信息列表中具体的换乘线路信息
        for (int j = 0; j < value.length; j++) {
          Line transferLine = value[j];

          if (CustomRegExp.oneDigit.hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 35.5 * j,
                child: Stack(
                  children: [
                    Widgets.transferLineIcon(transferLine),
                    Widgets.transferLineTextOneDigit(transferLine)
                  ],
                )));
          } else if (CustomRegExp.twoDigits
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 35.5 * j,
                child: Stack(
                  children: [
                    Widgets.transferLineIcon(transferLine),
                    Widgets.transferLineTextTwoDigits(transferLine)
                  ],
                )));
          } else if (CustomRegExp.twoDigits
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 35.5 * j,
                child: Stack(
                  children: [
                    Widgets.transferLineIcon(transferLine),
                    Widgets.transferLineTextTwoDigits(transferLine)
                  ],
                )));
          } else if (CustomRegExp.oneDigitOneCharacter
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 35.5 * j,
                child: Stack(
                  children: [
                    Widgets.transferLineIcon(transferLine),
                    Widgets.transferLineTextOneDigitOneCharacter(transferLine)
                  ],
                )));
          } else if (CustomRegExp.twoCharacters
              .hasMatch(transferLine.lineNumberEN)) {
            {
              iconList.add(Positioned(
                  left: (lineLength / (stationList.length - 1)) * i,
                  top: 35.5 * j,
                  child: Stack(
                    children: [
                      Widgets.transferLineIcon(transferLine),
                      Widgets.transferLineTextTwoCharacters(transferLine)
                    ],
                  )));
            }
          }
        }
      }
    }
    return Stack(
      children: iconList,
    );
  }

  //显示站名
  Stack showStationName() {
    List<Container> tempList = [];
    double count = 0;
    for (Station value in stationList) {
      tempList.add(Container(
        padding: EdgeInsets.fromLTRB(
            (lineLength / (stationList.length - 1)) * count, 0, 0, 0),
        child: Container(
          //逆时针45度
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameCN,
            style: TextStyle(
              fontWeight: Util.railwayTransitLcdIsBoldFont,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ));
      tempList.add(Container(
        padding: EdgeInsets.fromLTRB(
            //英文站名做适当偏移
            15 + (lineLength / (stationList.length - 1)) * count,
            10,
            0,
            0),
        child: Container(
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameEN,
            style: TextStyle(
              fontWeight: Util.railwayTransitLcdIsBoldFont,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ));
      count++;
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

  //导入纹理
  @override
  void importPattern() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['png'],
      dialogTitle: '选择纹理图片文件',
    );
    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;
      setState(() {
        pattern = bytes;
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
        // 站点不能少于 2 或大于 maxStation
        if (stationsFromJson.length >= 2 &&
            stationsFromJson.length <= Util.railwayTransitLcdMaxStation) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          transferLineList.clear();
          currentStationListIndex = 0; //会导致显示的是前一个索引对应的站点
          terminusListIndex = 0;

          // 设置线路颜色和颜色变体
          lineNumber = jsonData['lineNumber'];
          lineNumberEN = jsonData['lineNumberEN'];
          lineColor = Util.hexToColor(jsonData['lineColor']);
          lineVariantColor = Util.hexToColor(jsonData['lineVariantColor']);
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
          terminusListValue = stationList[stationList.length - 1].stationNameCN;
          terminusListIndex = stationList.length - 1;
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 2) {
          alertDialog("错误", "站点数量不能小于 2");
        } else if (stationsFromJson.length > Util.railwayTransitLcdMaxStation) {
          alertDialog("错误", "直线型线路图站点数量不能大于 ${Util.railwayTransitLcdMaxStation}，请使用 U 形线路图");
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
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
          }
        } else if (currentStationListIndex! > terminusListIndex!) {
          for (int i = terminusListIndex!; i < stationList.length; i++) {
            currentStationListIndex = i;
            setState(() {});
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出主线路图
  Future<void> exportMainImage() async {
    String fileName =
        "已到站 ${currentStationListIndex! + 1} $currentStationListValue, $terminusListValue方向.png";
    await exportImage(context, stationList, _mainImageKey, fileName, false,
        exportWidthValue: exportWidthValue);
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

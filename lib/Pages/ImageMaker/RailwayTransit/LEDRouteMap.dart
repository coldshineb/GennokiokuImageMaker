// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Object/Line.dart';
import '../../../Object/Station.dart';
import '../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../Preference.dart';
import '../../../Util.dart';
import '../../../Util/CustomColors.dart';
import '../../../Util/CustomPainter.dart';
import '../../../Util/CustomRegExp.dart';
import '../../../Util/Widgets.dart';
import '../../../main.dart';
import '../../../Parent/ImageMaker/RailwayTransit/LEDRouteMap.dart'
    as LEDRouteMapParent;

class LEDRouteMapRoot extends StatelessWidget {
  const LEDRouteMapRoot({super.key});

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
      home: const LEDRouteMap(),
    );
  }
}

class LEDRouteMap extends StatefulWidget {
  const LEDRouteMap({super.key});

  @override
  LEDRouteMapState createState() => LEDRouteMapState();
}

class LEDRouteMapState extends State<LEDRouteMap>
    with LEDRouteMapParent.LEDRouteMap, ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 335;
  static const double imageWidth = 2572.8;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _passingImageKey = GlobalKey();
  final GlobalKey _directionImageKey = GlobalKey();
  final GlobalKey _passedImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //站名集合
  List<Station> stationList = [];

  //创建换乘线路列表的列表
  List<List<Line>> transferLineList = [];

  String lineNumber = "";
  String lineNumberEN = "";

  //线路颜色和颜色变体，默认透明，导入文件时赋值
  Color lineColor = Colors.transparent;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? nextStationListValue;
  String? terminusListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? nextStationListIndex;

  //是否显示原忆轨道交通品牌图标
  bool showLogo = true;

  //默认导出宽度
  int exportWidthValue = 3840;

  //线路线条宽度
  int lineLength = 2320;

  //设置项
  late bool generalIsDevMode;
  late bool generalIsScaleEnabled;
  late int railwayTransitLcdMaxStation;
  late bool railwayTransitLcdIsRouteColorSameAsLineColor;

  //获取设置项
  void getSetting() {
    generalIsDevMode = Preference.generalIsDevMode;
    generalIsScaleEnabled = Preference.generalIsScaleEnabled;
    railwayTransitLcdMaxStation = Util.railwayTransitLcdMaxStation;
    railwayTransitLcdIsRouteColorSameAsLineColor = HomeState.sharedPreferences
            ?.getBool(
                PreferenceKey.railwayTransitLcdIsRouteColorSameAsLineColor) ??
        DefaultPreference.railwayTransitLcdIsRouteColorSameAsLineColor;
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
                    child: const Text("下一站"),
                  ),
                  DropdownButton(
                    disabledHint: const Text(
                      "下一站",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ), //设置空时的提示文字
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        nextStationListIndex = stationList.indexWhere(
                            (element) =>
                                element.stationNameCN ==
                                value); //根据选择的站名，找到站名集合中对应的索引
                        nextStationListValue = value;
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    value: nextStationListValue,
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
                            transferLineList =
                                transferLineList.reversed.toList();
                            nextStationListIndex = stationList.length -
                                1 -
                                nextStationListIndex!; //反转站点索引
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
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                padding: const EdgeInsets.only(right: 15),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    //重置所有变量
                    _imageBytes = null;
                    stationList.clear();
                    transferLineList.clear();
                    lineColor = Colors.transparent;
                    nextStationListIndex = null;
                    nextStationListValue = null;
                    terminusListValue = null;
                    lineNumber = "";
                    lineNumberEN = "";
                    setState(() {});
                  },
                  tooltip: '重置',
                  child: const Icon(Icons.refresh),
                )),
            FloatingActionButton(
              heroTag: null,
              onPressed: () {
                setState(() {});
              },
              tooltip: '刷新设置',
              child: const Icon(Icons.settings_backup_restore),
            )
          ],
        ));
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
                  color:
                      Util.hexToColor(CustomColors.railwayTransitLCDBackground),
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
                      gennokiokuRailwayTransitLogoWidget(showLogo),
                      lineNumberIconWidget(lineColor, lineNumber, lineNumberEN),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 165, 0, 0),
                        child: showStationName(),
                      ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        padding: const EdgeInsets.fromLTRB(43, 207, 0, 0),
                        child: showTransferIcon(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(30, 201.5, 0, 0),
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
              //方向指示图
              RepaintBoundary(
                key: _directionImageKey,
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 202.5, 0, 0),
                        child: showRouteIcon(direction: true),
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
                        padding: const EdgeInsets.fromLTRB(50, 202.5, 0, 0),
                        child: showPassingRouteIcon(),
                      ),
                    ],
                  ),
                ),
              ),
              //已过站图
              RepaintBoundary(
                key: _passedImageKey,
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 202.5, 0, 0),
                        child: showPassedStationIcon(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
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
        child: MenuItemButton(
          onPressed: exportDynamicImage,
          child: const Text("导出当前站全部图"),
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
        height: 48,
        child: MenuItemButton(
          onPressed: exportDirectionImage,
          child: const Text("导出方向指示图"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportPassingImage,
          child: const Text("导出下一站图"),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 14),
        child: const Text("导出分辨率"),
      ),
      DropdownButton(
        items: LEDRouteMapParent.LEDRouteMap.resolutionList(),
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
    return Stack(
      children: [
        Positioned(
            child: Container(
          width: lineLength + 60,
          height: 2,
          color: lineColor,
        ))
      ],
    );
  }

  //显示站点图标
  Stack showRouteIcon({bool direction = false}) {
    List<Container> iconList = [];
    for (int i = 0; i < 4 * (stationList.length - 1); i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (lineLength / (4 * (stationList.length - 1))) * i, 0, 0, 0),
          child: CustomPaint(
            painter: LEDRouteMapStationIconPainter(
                direction
                    ? Colors.grey
                    : Util.hexToColor(CustomColors
                        .railwayTransitLEDRouteMapNotPassingStation),
                lineColor,
                5,
                1),
          )));
    }
    for (int i = 0; i < stationList.length; i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: LEDRouteMapStationIconPainter(
                direction
                    ? Colors.grey
                    : Util.hexToColor(CustomColors
                        .railwayTransitLEDRouteMapNotPassingStation),
                lineColor,
                8,
                2),
          )));
    }
    return Stack(
      children: iconList,
    );
  }

  //显示正在过站图标
  Stack showPassingRouteIcon() {
    List<Container> tempList = [];
    if (nextStationListIndex != null) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 +
                  (lineLength / (stationList.length - 1)) *
                      nextStationListIndex!,
              0,
              0,
              0),
          child: CustomPaint(
            painter:
                LEDRouteMapStationIconPainter(Colors.orange, lineColor, 8, 2),
          )));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示已过站图标
  Stack showPassedStationIcon() {
    List<Container> iconList = [];
    for (int i = 0; i < 4 * (nextStationListIndex! - 1); i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (lineLength / (4 * (stationList.length - 1))) * i, 0, 0, 0),
          child: CustomPaint(
            painter: LEDRouteMapStationIconPainter(Colors.red, lineColor, 5, 1),
          )));
    }
    for (int i = 0; i < nextStationListIndex!; i++) {
      iconList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (lineLength / (stationList.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: LEDRouteMapStationIconPainter(Colors.red, lineColor, 8, 2),
          )));
    }
    return Stack(
      children: iconList,
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
                top: 22.0 * j,
                child: Transform.scale(
                    scale: 20 / 34,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextTwoDigits(transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.twoDigits
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 22.0 * j,
                child: Transform.scale(
                    scale: 20 / 34,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextTwoDigits(transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.twoDigits
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 22.0 * j,
                child: Transform.scale(
                    scale: 20 / 34,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextTwoDigits(transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.oneDigitOneCharacter
              .hasMatch(transferLine.lineNumberEN)) {
            iconList.add(Positioned(
                left: (lineLength / (stationList.length - 1)) * i,
                top: 22.0 * j,
                child: Transform.scale(
                    scale: 20 / 34,
                    child: Stack(
                      children: [
                        Widgets.transferLineIcon(transferLine),
                        Widgets.transferLineTextTwoDigits(transferLine),
                      ],
                    ))));
          } else if (CustomRegExp.twoCharacters
              .hasMatch(transferLine.lineNumberEN)) {
            {
              iconList.add(Positioned(
                  left: (lineLength / (stationList.length - 1)) * i,
                  top: 22.0 * j,
                  child: Transform.scale(
                      scale: 20 / 34,
                      child: Stack(
                        children: [
                          Widgets.transferLineIcon(transferLine),
                          Widgets.transferLineTextTwoDigits(transferLine),
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
                letterSpacing: 4),
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
            stationsFromJson.length <= railwayTransitLcdMaxStation) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          transferLineList.clear();
          nextStationListIndex = 0; //会导致显示的是前一个索引对应的站点

          // 设置线路颜色
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
          nextStationListValue = stationList[0].stationNameCN;
          terminusListValue = stationList[stationList.length - 1].stationNameCN;
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 2) {
          alertDialog(context, "错误", "站点数量不能小于 2");
        } else if (stationsFromJson.length > railwayTransitLcdMaxStation) {
          alertDialog(context, "错误",
              "直线型线路图站点数量不能大于 ${railwayTransitLcdMaxStation}，请使用 U 形线路图");
        }
      } catch (e) {
        print('读取文件失败: $e');
        alertDialog(context, "错误", "选择的文件格式错误，或文件内容格式未遵循规范");
      }
    }
  }

  //导出全部图
  @override
  void exportAllImage() async {
    if (stationList.isNotEmpty) {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        for (int i = 0; i < stationList.length + 1; i++) {
          nextStationListIndex = i;
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              context,
              stationList,
              _passingImageKey,
              "$path${Util.pathSlash}下一站 ${nextStationListIndex! + 1} ${stationList[nextStationListIndex!].stationNameCN}.png",
              true,
              exportWidthValue: exportWidthValue);
          await exportImage(
              context,
              stationList,
              _passingImageKey,
              "$path${Util.pathSlash}下一站 ${nextStationListIndex! + 1} ${stationList[nextStationListIndex!].stationNameCN}.png",
              true,
              exportWidthValue: exportWidthValue);
          await exportImage(
              context,
              stationList,
              _mainImageKey,
              "$path${Util.pathSlash}运行中 ${nextStationListIndex! + 1} ${stationList[nextStationListIndex!].stationNameCN}, $terminusListValue方向.png",
              true,
              exportWidthValue: exportWidthValue);
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        margin: const EdgeInsets.all(10.0),
        behavior: SnackBarBehavior.floating,
        content: Text("图片已成功保存至: $path"),
      ));
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出当前站全部图
  Future<void> exportDynamicImage() async {
    if (stationList.isNotEmpty) {
      await exportMainImage();
      await exportPassingImage();
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出主线路图
  Future<void> exportMainImage() async {
    if (stationList.isNotEmpty) {
      String fileName = "线路图.png";
      await exportImage(context, stationList, _mainImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出方向指示图
  Future<void> exportDirectionImage() async {
    if (stationList.isNotEmpty) {
      String fileName = "方向指示.png";
      await exportImage(
          context, stationList, _directionImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出下一站图
  Future<void> exportPassingImage() async {
    if (stationList.isNotEmpty) {
      String fileName =
          "下一站 ${nextStationListIndex! + 1} $nextStationListValue.png";
      await exportImage(context, stationList, _passingImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  void nextStation() {
    if (nextStationListIndex == stationList.length - 1 ||
        nextStationListIndex == null) {
      return;
    } else {
      setState(() {
        nextStationListIndex = nextStationListIndex! + 1;
        nextStationListValue = stationList[nextStationListIndex!].stationNameCN;
      });
    }
  }

  void previousStation() {
    if (nextStationListIndex == 0 || nextStationListIndex == null) {
      return;
    } else {
      setState(() {
        nextStationListIndex = nextStationListIndex! - 1;
        nextStationListValue = stationList[nextStationListIndex!].stationNameCN;
      });
    }
  }
}
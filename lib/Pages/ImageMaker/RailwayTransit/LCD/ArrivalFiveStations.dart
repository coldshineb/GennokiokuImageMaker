// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/Station.dart';

import '../../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../../Parent/ImageMaker/RailwayTransit/LCD.dart';
import '../../../../Preference.dart';
import '../../../../Util.dart';
import '../../../../Util/CustomColors.dart';
import '../../../../Util/CustomPainter.dart';
import '../../../../main.dart';

class ArrivalFiveStationsRoot extends StatelessWidget {
  const ArrivalFiveStationsRoot({super.key});

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
      home: const ArrivalFiveStations(),
    );
  }
}

class ArrivalFiveStations extends StatefulWidget {
  const ArrivalFiveStations({super.key});

  @override
  ArrivalFiveStationsState createState() => ArrivalFiveStationsState();
}

class ArrivalFiveStationsState extends State<ArrivalFiveStations>
    with LCD, ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 335;
  static const double imageWidth = 1715.2;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _passingImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //背景纹理
  Uint8List? pattern;

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

  //运行方向，用于处理已到站与终点站为中间某一站时的线条显示，0为向左行，1为向右行
  int trainDirectionValue = 1;

  //是否显示原忆轨道交通品牌图标
  bool showLogo = true;

  //默认导出宽度
  int exportWidthValue = 2560;

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
                    child: const Text("（第一步）运行方向"),
                  ),
                  Container(
                    height: 48,
                    child: RadioMenuButton(
                        value: 0,
                        groupValue: trainDirectionValue,
                        onChanged: (v) {
                          setState(() {
                            trainDirectionValue = v!;
                          });
                        },
                        child: const Text("向左行")),
                  ),
                  Container(
                    height: 48,
                    child: RadioMenuButton(
                        value: 1,
                        groupValue: trainDirectionValue,
                        onChanged: (v) {
                          setState(() {
                            trainDirectionValue = v!;
                          });
                        },
                        child: const Text("向右行")),
                  )
                ]),
                MenuBar(style: menuStyle(context), children: [
                  Container(
                    padding: const EdgeInsets.only(top: 14, left: 7),
                    child: const Text("（第三步）当前站"),
                  ),
                  DropdownButton(
                    disabledHint: const Text(
                      "当前站",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ), //设置空时的提示文字
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        int indexWhere = stationList.indexWhere(
                            (element) => element.stationNameCN == value);
                        indexWhere;
                        if (indexWhere == 2) {
                          trainDirectionValue = 0;
                        } else if (indexWhere == stationList.length - 3) {
                          trainDirectionValue = 1;
                        }
                        currentStationListIndex =
                            indexWhere; //根据选择的站名，找到站名集合中对应的索引
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
                    child: const Text("（第二步）终点站"),
                  ),
                  DropdownButton(
                    disabledHint: const Text(
                      "终点站",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        int indexWhere = stationList.indexWhere(
                            (element) => element.stationNameCN == value);
                        indexWhere;
                        if (indexWhere == 2) {
                          trainDirectionValue = 0;
                        } else if (indexWhere == stationList.length - 3) {
                          trainDirectionValue = 1;
                        }
                        terminusListIndex = indexWhere;
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
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    child: const Text(
                      "注意：先选择终点站，再选择当前站，站名选择仅用于确定运行方向，不用于确定小交线区间",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    //重置所有变量
                    _imageBytes = null;
                    pattern = null;
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
                )),
            FloatingActionButton(
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
                          width: imageWidth,
                          height: imageHeight,
                          child: showStationName()),
                      Container(
                        padding: const EdgeInsets.fromLTRB(286, 154, 0, 0),
                        child: showRouteLine(),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(400, 167, 0, 0),
                        child: showRouteIcon(),
                      ),
                    ],
                  ),
                ),
              ),
              //已到站图
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
                        padding: const EdgeInsets.fromLTRB(400, 167, 0, 0),
                        child: showPassingRouteIcon(),
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
          onPressed: exportPassingImage,
          child: const Text("导出已到站图"),
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
    if (currentStationListIndex != null && terminusListIndex != null) {
      if (currentStationListIndex! < terminusListIndex!) {
        if (currentStationListIndex == 0) {
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(routeLineColor, true),
              )));
        } else if (currentStationListIndex == 1) {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(routeLineColor, true),
              )));
        } else if (currentStationListIndex == 2) {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(routeLineColor, true),
              )));
        } else if (currentStationListIndex == terminusListIndex! - 2) {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  true)));
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
        } else if (currentStationListIndex == terminusListIndex! - 1) {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  true)));
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
        } else {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  true)));
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(routeLineColor, true),
              )));
        }
      } else if (currentStationListIndex! > terminusListIndex!) {
        if (currentStationListIndex == stationList.length - 1) {
          lineList.add(Container(child: routeLine(routeLineColor, true)));
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(routeLineColor, false)));
        } else if (currentStationListIndex == stationList.length - 2) {
          lineList.add(Container(child: routeLine(routeLineColor, true)));
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
        } else if (currentStationListIndex == stationList.length - 3) {
          lineList.add(Container(child: routeLine(routeLineColor, true)));
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
        } else if (currentStationListIndex == terminusListIndex! + 2) {
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(
                    Util.hexToColor(
                        CustomColors.railwayTransitLCDPassedStationVariant),
                    true),
              )));
        } else if (currentStationListIndex == terminusListIndex! + 1) {
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(
                    Util.hexToColor(
                        CustomColors.railwayTransitLCDPassedStationVariant),
                    true),
              )));
        } else {
          lineList.add(Container(child: routeLine(routeLineColor, true)));
          lineList.add(Container(child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(routeLineColor, false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(
                    Util.hexToColor(
                        CustomColors.railwayTransitLCDPassedStationVariant),
                    true),
              )));
        }
      } else {
        if (trainDirectionValue == 0) {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 1007),
              child: Transform.rotate(
                angle: pi,
                child: routeLine(
                    Util.hexToColor(
                        CustomColors.railwayTransitLCDPassedStationVariant),
                    true),
              )));
        } else {
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  true)));
          lineList.add(Container(
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 1),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 2),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
          lineList.add(Container(
              padding: const EdgeInsets.only(left: 223 * 3),
              child: routeLine(
                  Util.hexToColor(
                      CustomColors.railwayTransitLCDPassedStationVariant),
                  false)));
        }
      }
    }
    //非空判断
    return Stack(
      children: lineList,
    );
  }

  //线路
  Container routeLine(Color color, bool gradient) {
    return gradient
        ? Container(
            //间隔
            height: 27,
            child: Container(
                width: 115,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0), color],
                  ),
                )),
          )
        : Container(
            //间隔
            padding: const EdgeInsets.only(left: 115),
            height: 27,
            child: Container(
              width: 223,
              color: color,
            ),
          );
  }

  CustomPaint nextStationIconMediumPainter() {
    return CustomPaint(
      painter: LCDStationIconMediumPainter(
          lineColor: railwayTransitLcdIsRouteColorSameAsLineColor
              ? lineColor
              : Colors.green,
          lineVariantColor: railwayTransitLcdIsRouteColorSameAsLineColor
              ? lineVariantColor
              : Colors.green[300],
          shadow: true),
    );
  }

  CustomPaint passedStationIconMediumPainter() {
    return CustomPaint(
      painter: LCDStationIconMediumPainter(
          lineColor:
              Util.hexToColor(CustomColors.railwayTransitLCDPassedStation),
          lineVariantColor: Util.hexToColor(
              CustomColors.railwayTransitLCDPassedStationVariant),
          shadow: true),
    );
  }

  CustomPaint passedStationIconBigPainter() {
    return CustomPaint(
      painter: LCDStationIconBigPainter(
          lineColor:
              Util.hexToColor(CustomColors.railwayTransitLCDPassedStation),
          lineVariantColor: Util.hexToColor(
              CustomColors.railwayTransitLCDPassedStationVariant),
          shadow: true),
    );
  }

  //显示站点图标  与 showRouteLine 类似
  Stack showRouteIcon() {
    List<Container> iconList = [];
    if (stationList.isNotEmpty) {
      //当前站在终点站左
      if (currentStationListIndex! < terminusListIndex!) {
        //当前站为第1站
        if (currentStationListIndex == 0) {
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 0),
              child: passedStationIconBigPainter()));
          for (int i = 1; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
        //当前站为第2站
        else if (currentStationListIndex == 1) {
          for (int i = 0; i < 1; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 1),
              child: passedStationIconBigPainter()));
          for (int i = 2; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
        //当前站为末2站
        else if (currentStationListIndex == terminusListIndex! - 1) {
          for (int i = 0; i < 3; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 3),
              child: passedStationIconBigPainter()));
          for (int i = 4; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
        //当前站为第3站~末3站
        else {
          for (int i = 0; i < 2; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 2),
              child: passedStationIconBigPainter()));
          for (int i = 3; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
      }
      //当前站在终点站右
      else if (currentStationListIndex! > terminusListIndex!) {
        //当前站为末1站
        if (currentStationListIndex == stationList.length - 1) {
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 4),
              child: passedStationIconBigPainter()));
          for (int i = 0; i < 4; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
        //当前站为末2站
        else if (currentStationListIndex == stationList.length - 2) {
          for (int i = 4; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 3),
              child: passedStationIconBigPainter()));
          for (int i = 0; i < 3; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
        }
        //当前站为第2站
        else if (currentStationListIndex == terminusListIndex! + 1) {
          for (int i = 0; i < 1; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 1),
              child: passedStationIconBigPainter()));
          for (int i = 2; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
        }
        //当前站为第3站~末3站
        else {
          for (int i = 0; i < 2; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: nextStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 2),
              child: passedStationIconBigPainter()));
          for (int i = 3; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
        }
      }
      //当前站与终点站相同
      else {
        //右行
        if (trainDirectionValue == 1) {
          for (int i = 0; i < 4; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(
              padding: const EdgeInsets.only(left: 223.0 * 4),
              child: passedStationIconBigPainter()));
        }
        //左行
        else {
          for (int i = 1; i < 5; i++) {
            iconList.add(Container(
                padding: EdgeInsets.only(left: 223.0 * i),
                child: passedStationIconMediumPainter()));
          }
          iconList.add(Container(child: passedStationIconBigPainter()));
        }
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
      //当前站在终点站左
      if (currentStationListIndex! < terminusListIndex!) {
        //当前站为第1站
        if (currentStationListIndex == 0) {
          tempList.add(Container(
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为第2站
        else if (currentStationListIndex == 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为末2站
        else if (currentStationListIndex == terminusListIndex! - 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 3, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为第3站~末3站
        else {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 2, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
      }
      //当前站在终点站右
      else if (currentStationListIndex! > terminusListIndex!) {
        //当前站为第2站
        if (currentStationListIndex == terminusListIndex! + 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为末2站
        else if (currentStationListIndex == stationList.length - 2) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 3, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为末1站
        else if (currentStationListIndex == stationList.length - 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 4, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //当前站为第3站~末3站
        else {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(446, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
      }
      //当前站与终点站相同
      else {
        //第1站
        if (currentStationListIndex == 0) {
          tempList.add(Container(
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //第2站
        else if (currentStationListIndex == 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //末1站
        else if (currentStationListIndex == terminusListIndex!) {
          if (trainDirectionValue == 0) {
            tempList.add(Container(
                padding: const EdgeInsets.fromLTRB(223 * 0, 0, 0, 0),
                child: CustomPaint(
                    painter: LCDStationIconBigPainter(
                        lineColor: Util.hexToColor(
                            CustomColors.railwayTransitLCDPassingStation),
                        lineVariantColor: Util.hexToColor(CustomColors
                            .railwayTransitLCDPassingStationVariant),
                        shadow: false))));
          } else {
            tempList.add(Container(
                padding: const EdgeInsets.fromLTRB(223 * 4, 0, 0, 0),
                child: CustomPaint(
                    painter: LCDStationIconBigPainter(
                        lineColor: Util.hexToColor(
                            CustomColors.railwayTransitLCDPassingStation),
                        lineVariantColor: Util.hexToColor(CustomColors
                            .railwayTransitLCDPassingStationVariant),
                        shadow: false))));
          }
        }
        //末2站
        else if (currentStationListIndex == terminusListIndex! - 1) {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 3, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
        //第3站~末3站
        else {
          tempList.add(Container(
              padding: const EdgeInsets.fromLTRB(223 * 2, 0, 0, 0),
              child: CustomPaint(
                  painter: LCDStationIconBigPainter(
                      lineColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStation),
                      lineVariantColor: Util.hexToColor(
                          CustomColors.railwayTransitLCDPassingStationVariant),
                      shadow: false))));
        }
      }
    }
    return Stack(
      children: tempList,
    );
  }

  //显示站名
  Stack showStationName() {
    List<Positioned> tempList = [];
    if (stationList.isNotEmpty && currentStationListIndex != null) {
      //选站时注意不要让当前站在终点站左边时，终点站为前四站；当前站在终点站右边时，终点站为末四站。（五站图怎么可能只显示四站！！！）懒得写异常处理了，使用时自觉些
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
        //当前站为末2站
        else if (currentStationListIndex == terminusListIndex! - 1) {
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
        //当前站为第2站
        else if (currentStationListIndex == terminusListIndex! + 1) {
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
      //当前站与终点站相同
      else if (currentStationListIndex == terminusListIndex) {
        //当前站为第3站~末3站
        if (currentStationListIndex! > 1 &&
            currentStationListIndex! < stationList.length - 2) {
          if (trainDirectionValue == 1) {
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
          } else {
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
        //当前站为末2站
        else if (currentStationListIndex == stationList.length - 2) {
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
            stationsFromJson.length <= railwayTransitLcdMaxStation) {
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
          terminusListValue = stationList[stationList.length - 1].stationNameCN;
          terminusListIndex = stationList.length - 1;
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 5) {
          alertDialog(context, "错误", "站点数量不能小于 5");
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
                _passingImageKey,
                "$path${Util.pathSlash}已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _passingImageKey,
                "$path${Util.pathSlash}已到站 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 五站图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
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
                _passingImageKey,
                "$path${Util.pathSlash}已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _passingImageKey,
                "$path${Util.pathSlash}已到站 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 五站图 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          margin: const EdgeInsets.all(10.0),
          behavior: SnackBarBehavior.floating,
          content: Text("图片已成功保存至: $path"),
        ));
      }
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
      String fileName =
          "已到站 五站图 ${currentStationListIndex! + 1} $currentStationListValue, $terminusListValue方向.png";
      await exportImage(context, stationList, _mainImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出已到站图
  Future<void> exportPassingImage() async {
    if (stationList.isNotEmpty) {
      String fileName =
          "已到站 ${currentStationListIndex! + 1} $currentStationListValue.png";
      await exportImage(context, stationList, _passingImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
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

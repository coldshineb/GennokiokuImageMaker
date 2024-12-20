// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../Util.dart';
import '../../../../../Util/CustomColors.dart';
import '../../../../Object/EntranceCover.dart';
import '../../../../Object/Line.dart';
import '../../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../../Parent/ImageMaker/RailwayTransit/StationEntrance.dart';
import '../../../../Preference.dart';
import '../../../../Util/CustomRegExp.dart';

class StationEntranceCoverRoot extends StatelessWidget {
  const StationEntranceCoverRoot({super.key});

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
      home: const StationEntranceCover(),
    );
  }
}

class StationEntranceCover extends StatefulWidget {
  const StationEntranceCover({super.key});

  @override
  StationEntranceCoverState createState() => StationEntranceCoverState();
}

class StationEntranceCoverState extends State<StationEntranceCover>
    with StationEntrance, ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 240;
  static const double imageWidth = 1440;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  String? stationValue; //站名
  String? entranceValue; //出入口编号
  String? entranceListValue; //下拉列表内容  站名+出入口编号
  int? entranceIndex; //下拉列表选择站名和出入口编号对应的索引

  //站名和出入口编号集合
  List<EntranceCover> entranceList = [];

  //是否显示原忆轨道交通品牌图标
  bool showLogo = true;

  //默认导出宽度
  int exportWidthValue = 1920;

  //设置项
  late bool generalIsDevMode;
  late bool generalIsScaleEnabled;

  //获取设置项
  void getSetting() {
    generalIsDevMode = Preference.generalIsDevMode;
    generalIsScaleEnabled = Preference.generalIsScaleEnabled;
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
                    child: const Text("站名与入口编号")),
                DropdownButton(
                  disabledHint: const Text("站名与入口编号",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 14)), //设置空时的提示文字
                  items: showEntranceList(entranceList),
                  onChanged: (value) {
                    try {
                      entranceIndex = entranceList.indexWhere((element) =>
                          element.stationNameCN ==
                              value.toString().split(" ")[0] &&
                          element.entranceNumber ==
                              value.toString().split(
                                  " ")[1]); //根据选择的站名和出入口编号，找到站名和出入口编号集合中对应的索引
                      entranceListValue = value;
                      setState(() {});
                    } catch (e) {
                      print(e);
                    }
                  },
                  value: entranceListValue,
                ),
                Container(
                    height: 48,
                    child: MenuItemButton(
                        onPressed: previousStation,
                        child: const Row(children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text("上一个")
                        ]))),
                Container(
                  height: 48,
                  child: MenuItemButton(
                      onPressed: nextStation,
                      child: const Row(children: [
                        Icon(Icons.arrow_forward),
                        SizedBox(width: 5),
                        Text("下一个")
                      ])),
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
                  entranceIndex = null;
                  entranceList.clear();
                  stationValue = null;
                  entranceValue = null;
                  entranceListValue = null;
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
                  color: Util.hexToColor(
                      CustomColors.railwayTransitCoverBackground),
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
                      gennokiokuRailwayTransitLogoWidgetVertical(showLogo),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: line(),
                        ),
                      ),
                      // Container(
                      //   width: imageWidth,
                      //   height: imageHeight,
                      //   child: Stack(
                      //     children: entrance(),
                      //   ),
                      // ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: entranceNumber(),
                        ),
                      ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: stationName(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Container gennokiokuRailwayTransitLogoWidgetVertical(bool show) {
    return show
        ? Container(
            padding: const EdgeInsets.only(left: 18, top: 39),
            child: SvgPicture.asset(
                height: 167,
                width: 167,
                "assets/image/railwayTransitLogoVertical.svg"))
        : Container();
  }

  //线路标识
  List<Positioned> line() {
    List<Positioned> list = [];
    if (entranceList.isNotEmpty) {
      for (int i = 0; i < entranceList[entranceIndex!].lines.length; i++) {
        var value = entranceList[entranceIndex!].lines[i];
        list.add(Positioned(
          left: 217 + 109.0 * i,
          child: Container(height: 198, width: 95, color: Colors.white),
        ));
        if (CustomRegExp.oneDigit.hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 7,
            left: -911 + 218.0 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber,
                style: TextStyle(
                  fontSize: 95,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 120,
            left: -911 + 218.0 * i,
            right: 0,
            child: Center(
              child: Center(
                child: Text(
                  "号线",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Util.hexToColor(value.lineColor),
                  ),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.twoDigits.hasMatch(value.lineNumber) ||
            CustomRegExp.oneDigitOneCharacter.hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 7,
            left: -895 + 218.0 * i,
            right: 0,
            child: Center(
              child: Transform(
                transform: Matrix4.diagonal3Values(0.8, 1.0, 1.0),
                child: Text(
                  value.lineNumber,
                  style: TextStyle(
                    letterSpacing: -5,
                    fontSize: 95,
                    color: Util.hexToColor(value.lineColor),
                  ),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 120,
            left: -911 + 218.0 * i,
            right: 0,
            child: Center(
              child: Center(
                child: Text(
                  "号线",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Util.hexToColor(value.lineColor),
                  ),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.fourChineseCharacters
            .hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 43.5,
            left: -909 + 218.0 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(0, 2),
                style: TextStyle(
                  fontSize: 38,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 89.5,
            left: -909 + 218.0 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(2, 4),
                style: TextStyle(
                  fontSize: 38,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.fiveChineseCharacters
            .hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 51,
            left: -909 + 218.0 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(0, 3),
                style: TextStyle(
                  fontSize: 30,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 89.5,
            left: -909 + 218.0 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(3, 5),
                style: TextStyle(
                  fontSize: 38,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ));
        }

        list.add(Positioned(
          top: 143,
          left: -911 + 218.0 * i,
          right: 0,
          child: Center(
            child: Center(
              child: Text(
                "Line ${value.lineNumberEN}",
                style: TextStyle(
                  fontSize: 18.5,
                  color: Util.hexToColor(value.lineColor),
                ),
              ),
            ),
          ),
        ));
      }
    }
    return list;
  }

  //站名
  List<Positioned> stationName() {
    List<Positioned> list = [];
    if (entranceList.isNotEmpty) {
      //根据不同线路个数调整站名位置
      if (entranceList[entranceIndex!].lines.length == 3) {
        list.add(Positioned(
            top: 43,
            left: 195,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameCN,
              style: const TextStyle(
                  letterSpacing: 4,
                  color: Colors.white,
                  fontSize: 80,
                  fontFamily: "HYYanKaiW"),
            )));
        list.add(Positioned(
            top: 131,
            left: 191.5,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameEN,
              style: const TextStyle(
                  wordSpacing: 2, color: Colors.white, fontSize: 30),
            )));
      } else if (entranceList[entranceIndex!].lines.length == 4) {
        list.add(Positioned(
            top: 43,
            left: 455,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameCN,
              style: const TextStyle(
                  letterSpacing: 4,
                  color: Colors.white,
                  fontSize: 80,
                  fontFamily: "HYYanKaiW"),
            )));
        list.add(Positioned(
            top: 131,
            left: 451.5,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameEN,
              style: const TextStyle(
                  wordSpacing: 2, color: Colors.white, fontSize: 30),
            )));
      } else {
        list.add(Positioned(
            top: 43,
            left: 65,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameCN,
              style: const TextStyle(
                  letterSpacing: 4,
                  color: Colors.white,
                  fontSize: 80,
                  fontFamily: "HYYanKaiW"),
            )));
        list.add(Positioned(
            top: 131,
            left: 61.5,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              entranceList[entranceIndex!].stationNameEN,
              style: const TextStyle(
                  wordSpacing: 2, color: Colors.white, fontSize: 30),
            )));
      }
    }
    return list;
  }

  //出入口编号
  List<Positioned> entranceNumber() {
    return entranceList.isNotEmpty
        ? <Positioned>[
            Positioned(
                top: 24,
                right: 63.5,
                child: RichText(
                  text: TextSpan(
                    text: entranceList[entranceIndex!]
                        .entranceNumber
                        .substring(0, 1),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 122,
                        fontFamily: "GennokiokuLCDFont"),
                    children: <TextSpan>[
                      TextSpan(
                        text: entranceList[entranceIndex!]
                            .entranceNumber
                            .substring(1),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 62,
                            fontFamily: "GennokiokuLCDFont"),
                      ),
                    ],
                  ),
                )),
          ]
        : <Positioned>[];
  }

  //"入口 Entrance"标识
  List<Positioned> entrance() {
    return <Positioned>[
      const Positioned(
          top: 54,
          left: 1181.5,
          child: Text(
            "入口",
            style:
                TextStyle(letterSpacing: 3, color: Colors.white, fontSize: 48),
          )),
      const Positioned(
          top: 112,
          left: 1181.5,
          child: Text(
            "Entrance",
            style: TextStyle(
                letterSpacing: 2.45, color: Colors.white, fontSize: 48),
          ))
    ];
  }

  @override
  MenuBar importAndExportMenubar() {
    return MenuBar(style: menuStyle(context), children: [
      generalIsDevMode ? importImageMenuItemButton(_importImage) : Container(),
      importStationJsonMenuItemButton(importStationJson),
      const VerticalDivider(thickness: 2),
      exportAllImageMenuItemButton(exportAllImage),
      const VerticalDivider(),
      exportMainImageMenuItemButton(exportMainImage),
      Container(
          padding: const EdgeInsets.only(top: 14), child: const Text("导出分辨率")),
      DropdownButton(
        items: resolutionList(),
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
  void importStationJson() async {
    List<dynamic> stationsFromJson = [];
    Map<String, dynamic> jsonData;

    // 选择 JSON 文件
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        withData: true,
        allowedExtensions: ['json'],
        dialogTitle: '选择站名 JSON 文件',
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

        if (stationsFromJson.isNotEmpty) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          entranceList.clear();

          for (dynamic item in stationsFromJson) {
            List<dynamic> entranceNumbers = item['entranceNumbers'];
            List<dynamic> lines = item['lines'];

            //每次添加新的线路数据前清空上一循环添加的数据
            List<Line> line = [];

            //获取线路信息
            for (var value in lines) {
              var lineNumber = value['lineNumber'];
              var lineNumberEN = value['lineNumberEN'];
              var lineColor = value['lineColor'];
              line.add(Line(lineNumber,
                  lineNumberEN: lineNumberEN, lineColor: lineColor));
            }

            //获取入口编号
            for (var value1 in entranceNumbers) {
              //最终在这里将所有站点信息添加进集合
              EntranceCover station = EntranceCover(
                stationNameCN: item['stationNameCN'],
                stationNameEN: item['stationNameEN'],
                entranceNumber: value1,
                lines: line,
              );
              entranceList.add(station);
            }
          }
          entranceListValue =
              "${entranceList[0].stationNameCN} ${entranceList[0].entranceNumber}"; //把第一个元素的信息给到下拉列表
          entranceIndex = 0; //设置默认显示第一张图

          // 刷新页面状态
          setState(() {});
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
    if (entranceList.isNotEmpty) {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        for (int i = 0; i < entranceList.length; i++) {
          entranceIndex = i;
          Directory(
                  "$path${Util.pathSlash}${entranceList[entranceIndex!].stationNameCN}")
              .create();
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              context,
              entranceList,
              _mainImageKey,
              "$path${Util.pathSlash}${entranceList[entranceIndex!].stationNameCN}${Util.pathSlash}出入口盖板 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png",
              true,
              exportWidthValue: exportWidthValue);
          await exportImage(
              context,
              entranceList,
              _mainImageKey,
              "$path${Util.pathSlash}${entranceList[entranceIndex!].stationNameCN}${Util.pathSlash}出入口盖板 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png",
              true,
              exportWidthValue: exportWidthValue);
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

  //导出当前图
  Future<void> exportMainImage() async {
    if (entranceList.isNotEmpty) {
      String fileName =
          "出入口盖板 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png";
      await exportImage(context, entranceList, _mainImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  //导出分辨率选择下拉列表
  static List<DropdownMenuItem> resolutionList() {
    return [
      const DropdownMenuItem(
        value: 1920,
        child: Text("1920*320"),
      ),
      const DropdownMenuItem(
        value: 3840,
        child: Text("3840*640"),
      ),
      const DropdownMenuItem(
        value: 7680,
        child: Text("7680*1280"),
      )
    ];
  }

  void nextStation() {
    if (entranceList.isNotEmpty) {
      if (entranceIndex! < entranceList.length - 1) {
        entranceIndex = entranceIndex! + 1;
      } else {
        entranceIndex = 0;
      }
      entranceListValue =
          "${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}";
      setState(() {});
    }
  }

  void previousStation() {
    if (entranceList.isNotEmpty) {
      if (entranceIndex! > 0) {
        entranceIndex = entranceIndex! - 1;
      } else {
        entranceIndex = entranceList.length - 1;
      }
      entranceListValue =
          "${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}";
      setState(() {});
    }
  }
}

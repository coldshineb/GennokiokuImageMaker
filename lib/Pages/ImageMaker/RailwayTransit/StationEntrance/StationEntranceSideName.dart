// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../Util.dart';
import '../../../../Object/EntranceCover.dart';
import '../../../../Object/Line.dart';
import '../../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../../Parent/ImageMaker/RailwayTransit/StationEntrance.dart';
import '../../../../Preference.dart';
import '../../../../Util/CustomRegExp.dart';

class StationEntranceSideNameRoot extends StatelessWidget {
  const StationEntranceSideNameRoot({super.key});

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
      home: const StationEntranceSideName(),
    );
  }
}

class StationEntranceSideName extends StatefulWidget {
  const StationEntranceSideName({super.key});

  @override
  StationEntranceSideNameState createState() => StationEntranceSideNameState();
}

class StationEntranceSideNameState extends State<StationEntranceSideName>
    with StationEntrance, ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 540;
  static const double imageWidth = 1080;

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

  //默认导出宽度
  int exportWidthValue = 2160;

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
                        child: Row(children: [
                          Icon(Icons.arrow_back),
                          SizedBox(width: 5),
                          Text("上一个")
                        ])),
                  ),
                  Container(
                    height: 48,
                    child: MenuItemButton(
                        onPressed: nextStation,
                        child: Row(children: [
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
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: line(),
                        ),
                      ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: entrance(),
                        ),
                      ),
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

  //线路标识
  List<Positioned> line() {
    List<Positioned> list = [];
    if (entranceList.isNotEmpty) {
      List entranceListForLine = entranceList[entranceIndex!]
          .lines
          .reversed
          .toList(); //将线路信息倒序排列，以便从右向左显示
      for (int i = 0; i < entranceListForLine.length; i++) {
        var value = entranceListForLine[i];
        //经过测试，出入口侧方站名下的线路标识大小为出入口盖板中的0.6倍，间距为0.525倍
        list.add(Positioned(
            top: 160,
            left: 360 - 95.0 * 0.6 * i,
            child: Container(
              height: 198.0 * 0.6,
              width: 95.0 * 0.6,
              color: Util.hexToColor(value.lineColor),
            )));
        if (CustomRegExp.oneDigit.hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 165,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber,
                style: TextStyle(
                  fontSize: 95 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 232,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Center(
                child: Text(
                  "号线",
                  style: TextStyle(
                    fontSize: 20 * 0.6,
                    letterSpacing: 3,
                    color: Util.getTextColorForBackground(
                        Util.hexToColor(value.lineColor)),
                  ),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.twoDigits.hasMatch(value.lineNumber) ||
            CustomRegExp.oneDigitOneCharacter.hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 165,
            left: -293 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Transform(
                transform: Matrix4.diagonal3Values(0.8, 1.0, 1.0),
                child: Text(
                  value.lineNumber,
                  style: TextStyle(
                    letterSpacing: -5,
                    fontSize: 95 * 0.6,
                    color: Util.getTextColorForBackground(
                        Util.hexToColor(value.lineColor)),
                  ),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 232,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Center(
                child: Text(
                  "号线",
                  style: TextStyle(
                    fontSize: 20 * 0.6,
                    letterSpacing: 3,
                    color: Util.getTextColorForBackground(
                        Util.hexToColor(value.lineColor)),
                  ),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.fourChineseCharacters
            .hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 186,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(0, 2),
                style: TextStyle(
                  fontSize: 38 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 214,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(2, 4),
                style: TextStyle(
                  fontSize: 38 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
                ),
              ),
            ),
          ));
        } else if (CustomRegExp.fiveChineseCharacters
            .hasMatch(value.lineNumber)) {
          list.add(Positioned(
            top: 190,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(0, 3),
                style: TextStyle(
                  fontSize: 30 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
                ),
              ),
            ),
          ));
          list.add(Positioned(
            top: 214,
            left: -302 - 218.0 * 0.525 * i,
            right: 0,
            child: Center(
              child: Text(
                value.lineNumber.substring(3, 5),
                style: TextStyle(
                  fontSize: 38 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
                ),
              ),
            ),
          ));
        }
        list.add(Positioned(
          top: 143 + 104,
          left: -302 - 218.0 * 0.525 * i,
          right: 0,
          child: Center(
            child: Center(
              child: Text(
                "Line ${value.lineNumberEN}",
                style: TextStyle(
                  fontSize: 18.5 * 0.6,
                  color: Util.getTextColorForBackground(
                      Util.hexToColor(value.lineColor)),
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
      list.add(Positioned(
          top: 145,
          left: 432,
          child: Text(
            textAlign: TextAlign.center,
            entranceList[entranceIndex!].stationNameCN,
            style: const TextStyle(
                letterSpacing: 4,
                color: Colors.black,
                fontSize: 81,
                fontFamily: "HYYanKaiW"),
          )));
      list.add(Positioned(
          top: 240,
          left: 444,
          child: Text(
            textAlign: TextAlign.center,
            entranceList[entranceIndex!].stationNameEN,
            style: const TextStyle(
                wordSpacing: 2, color: Colors.black, fontSize: 30),
          )));
    }
    return list;
  }

  //"出入口 Exit & Entrance"标识
  List<Positioned> entrance() {
    return <Positioned>[
      const Positioned(
          top: 335,
          left: 475,
          child: Text(
            "出入口",
            style: TextStyle(color: Colors.black, fontSize: 33),
          )),
      const Positioned(
          top: 375,
          left: 475,
          child: Text(
            "Exit & Entrance",
            style: TextStyle(color: Colors.black, fontSize: 33),
          ))
    ];
  }

  //出入口编号
  List<Positioned> entranceNumber() {
    return entranceList.isNotEmpty
        ? <Positioned>[
            Positioned(
                top: 310,
                left: 380,
                child: RichText(
                  text: TextSpan(
                    text: entranceList[entranceIndex!]
                        .entranceNumber
                        .substring(0, 1),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 88,
                        fontFamily: "GennokiokuLCDFont"),
                    children: <TextSpan>[
                      TextSpan(
                        text: entranceList[entranceIndex!]
                            .entranceNumber
                            .substring(1),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 52,
                            fontFamily: "GennokiokuLCDFont"),
                      ),
                    ],
                  ),
                )),
          ]
        : <Positioned>[];
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

  //导入站名文件
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
              "$path${Util.pathSlash}${entranceList[entranceIndex!].stationNameCN}${Util.pathSlash}出入口侧方站名 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png",
              true,
              exportWidthValue: exportWidthValue);
          await exportImage(
              context,
              entranceList,
              _mainImageKey,
              "$path${Util.pathSlash}${entranceList[entranceIndex!].stationNameCN}${Util.pathSlash}出入口侧方站名 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png",
              true,
              exportWidthValue: exportWidthValue);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
          "出入口侧方站名 ${entranceList[entranceIndex!].stationNameCN} ${entranceList[entranceIndex!].entranceNumber}.png";
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
        value: 1080,
        child: Text("1080*540"),
      ),
      const DropdownMenuItem(
        value: 2160,
        child: Text("2160*1080"),
      ),
      const DropdownMenuItem(
        value: 4320,
        child: Text("4320*2160"),
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

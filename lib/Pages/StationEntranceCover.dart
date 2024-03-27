// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/Object/EntranceCover.dart';
import 'package:main/Util/CustomRegExp.dart';

import '../../Parent/LCD.dart';
import '../../Util.dart';
import '../../Util/CustomColors.dart';
import '../../Util/Widgets.dart';
import '../Object/Line.dart';

void loadFont() async {
  var fontLoader1 = FontLoader("GennokiokuLCDFont");
  fontLoader1
      .addFont(rootBundle.load('assets/font/FZLTHProGlobal-Regular.TTF'));
  var fontLoader2 = FontLoader("STZongyi");
  fontLoader2.addFont(rootBundle.load('assets/font/STZongyi.ttf'));
  await fontLoader1.load();
  await fontLoader2.load();
}

class StationEntranceCoverRoot extends StatelessWidget {
  const StationEntranceCoverRoot({super.key});

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
      home: StationEntranceCover(),
    );
  }
}

class StationEntranceCover extends StatefulWidget {
  @override
  StationEntranceCoverState createState() => StationEntranceCoverState();
}

class StationEntranceCoverState extends State<StationEntranceCover> with LCD {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 240;
  static const double imageWidth = 1440;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //站名集合
  List<EntranceCover> stationList = [];

  //默认导出宽度
  int exportWidthValue = 1920;

  int? stationIndex;

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
                          color: Util.hexToColor(
                              CustomColors.backgroundColorCover),
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
                                padding:
                                    const EdgeInsets.only(left: 18, top: 39),
                                child: SvgPicture.asset(
                                    height: 167,
                                    width: 167,
                                    "assets/image/railwayTransitLogoVertical.svg"),
                              ),
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
            ),
          ),
        ],
      ),
      //重置按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //重置所有变量
          _imageBytes = null;
          stationIndex = null;
          stationList.clear();
          setState(() {});
        },
        tooltip: '重置',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<Positioned> line() {
    List<Positioned> list = [];
    if (stationIndex != null) {
      for (int i = 0; i < stationList[stationIndex!].lines.length; i++) {
        var value = stationList[stationIndex!].lines[i];
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

  List<Positioned> stationName() {
    return <Positioned>[
      const Positioned(
          top: 43,
          left: 65,
          right: 0,
          child: Text(
            textAlign: TextAlign.center,
            "赤羽",
            style: TextStyle(
                letterSpacing: 4,
                color: Colors.red,
                fontSize: 80,
                fontFamily: "HYYanKaiW"),
          )),
      const Positioned(
          top: 131,
          left: 61.5,
          right: 0,
          child: Text(
            textAlign: TextAlign.center,
            "CHI YU",
            style: TextStyle(wordSpacing: 2, color: Colors.red, fontSize: 30),
          )),
    ];
  }

  List<Positioned> entranceNumber() {
    return <Positioned>[
      const Positioned(
          top: 24,
          right: 263.5,
          child: Text(
            textAlign: TextAlign.right,
            "A",
            style: TextStyle(color: Colors.red, fontSize: 122),
          )),
    ];
  }

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
            "导入站名",
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
        padding: const EdgeInsets.only(top: 14),
        child: const Text(
          "导出分辨率",
          style: TextStyle(color: Colors.black),
        ),
      ),
      DropdownButton(
        items: Widgets.resolutionListCover(),
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

        if (stationsFromJson.isNotEmpty) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();

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
                entranceNumbers: value1,
                lines: line,
              );
              stationList.add(station);
            }
          }

          stationIndex = 0;
          // 刷新页面状态
          setState(() {});
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
        setState(() {});
        //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
        //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
        //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
        await exportImage(
            _mainImageKey,
            "$path\\出入口盖板 ${stationList[stationIndex!].stationNameCN} + 出入口编号.png",
            false);
        await exportImage(
            _mainImageKey,
            "$path\\出入口盖板 ${stationList[stationIndex!].stationNameCN} + 出入口编号.png",
            false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path"),
        ));
      }
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
              "出入口盖板 ${stationList[stationIndex!].stationNameCN} + 出入口编号.png"),
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

// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/Station.dart';

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
  List<Station> stationList = [];

  String lineNumber = "";
  String lineNumberEN = "";

  //线路颜色和颜色变体，默认透明，导入文件时赋值
  Color lineColor = Colors.transparent;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? currentStationListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? currentStationListIndex;

  //默认导出宽度
  int exportWidthValue = 1920;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: '返回',
        ),
        title: const Text('出入口盖板'),
        elevation: 20,
      ),
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
                    "站名",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "站名",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ), //设置空时的提示文字
                  items: showStationList(stationList),
                  onChanged: (value) {
                    try {
                      int indexWhere = stationList.indexWhere(
                          (element) => element.stationNameCN == value);
                      indexWhere;
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
                          color: Util.hexToColor(CustomColors.backgroundColorCover),
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
        // 站点不能少于 2 或大于 32
        if (stationsFromJson.isNotEmpty) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          currentStationListIndex = 0; //会导致显示的是前一个索引对应的站点

          // 设置线路颜色和颜色变体
          lineNumber = jsonData['lineNumber'];
          lineNumberEN = jsonData['lineNumberEN'];
          lineColor = Util.hexToColor(jsonData['lineColor']);
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
        for (int i = 0; i < stationList.length - 1; i++) {
          currentStationListIndex = i;
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              _mainImageKey,
              "$path\\出入口盖板 ${stationList[currentStationListIndex!].stationNameCN} + 出入口编号.png",
              false);
          await exportImage(
              _mainImageKey,
              "$path\\出入口盖板 ${stationList[currentStationListIndex!].stationNameCN} + 出入口编号.png",
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

  //导出主线路图
  Future<void> exportMainImage() async {
    if (stationList.isNotEmpty) {
      await exportImage(
          _mainImageKey,
          await getExportPath(context, "保存",
              "出入口盖板 ${stationList[currentStationListIndex!].stationNameCN} + 出入口编号.png"),
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
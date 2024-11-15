// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../Util.dart';
import '../../../../Preference.dart';
import '../../../Object/Station.dart';
import '../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../Util/CustomColors.dart';

class PlatformLevelSideNameRoot extends StatelessWidget {
  const PlatformLevelSideNameRoot({super.key});

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
      home: const PlatformLevelSideName(),
    );
  }
}

class PlatformLevelSideName extends StatefulWidget {
  const PlatformLevelSideName({super.key});

  @override
  PlatformLevelSideNameState createState() => PlatformLevelSideNameState();
}

class PlatformLevelSideNameState extends State<PlatformLevelSideName>
    with ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 540;
  static const double imageWidth = 1080;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  int? stationListIndex; //站名索引
  String? stationListValue; //下拉列表选择站名

  //站名集合
  List<Station> stationList = [];

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
                      child: const Text("站名")),
                  DropdownButton(
                    disabledHint: const Text(
                      "站名",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ), //设置空时的提示文字
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        stationListIndex = stationList.indexWhere((element) =>
                            element.stationNameCN ==
                            value); //根据选择的站名，找到站名集合中对应的索引
                        stationListValue = value;
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    value: stationListValue,
                  ),
                  Row(
                    children: [
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
                    ],
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
                    stationListIndex = 0;
                    stationListValue = null;
                    stationList.clear();
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

  //站名
  List<Positioned> stationName() {
    List<Positioned> list = [];
    if (stationList.isNotEmpty) {
      list.add(Positioned(
          top: 145,
          left: 0,
          right: 0,
          child: Text(
            textAlign: TextAlign.center,
            stationList[stationListIndex!].stationNameCN,
            style: TextStyle(
                letterSpacing: 4,
                color: Util.hexToColor(
                    CustomColors.railwayTransitGeneralSignBackground),
                fontSize: 81,
                fontFamily: "HYYanKaiW"),
          )));
      list.add(Positioned(
          top: 240,
          left: 0,
          right: 0,
          child: Text(
            textAlign: TextAlign.center,
            stationList[stationListIndex!].stationNameEN,
            style: TextStyle(
                wordSpacing: 2,
                color: Util.hexToColor(
                    CustomColors.railwayTransitGeneralSignBackground),
                fontSize: 30),
          )));
    }
    return list;
  }

  @override
  MenuBar importAndExportMenubar() {
    return MenuBar(style: menuStyle(context), children: [
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

  //导入线路文件
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

        //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
        stationList.clear();
        stationListIndex = 0; //会导致显示的是前一个索引对应的站点

        for (dynamic item in stationsFromJson) {
          Station station = Station(
            stationNameCN: item['stationNameCN'],
            stationNameEN: item['stationNameEN'],
          );
          stationList.add(station);
        }

        //文件成功导入后将下拉菜单默认值设为第一站
        stationListValue = stationList[0].stationNameCN;
        setState(() {});
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
          stationListIndex = i;
          setState(() {});
          //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
          //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
          //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
          await exportImage(
              context,
              stationList,
              _mainImageKey,
              "$path${Util.pathSlash}站台层侧方站名 ${stationList[stationListIndex!].stationNameCN}.png",
              true,
              exportWidthValue: exportWidthValue);
          await exportImage(
              context,
              stationList,
              _mainImageKey,
              "$path${Util.pathSlash}站台层侧方站名 ${stationList[stationListIndex!].stationNameCN}.png",
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
    if (stationList.isNotEmpty) {
      String fileName =
          "站台层侧方站名 ${stationList[stationListIndex!].stationNameCN}.png";
      await exportImage(context, stationList, _mainImageKey, fileName, false,
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
    if (stationList.isNotEmpty) {
      if (stationListIndex! < stationList.length - 1) {
        stationListIndex = stationListIndex! + 1;
      } else {
        stationListIndex = 0;
      }
      stationListValue = stationList[stationListIndex!].stationNameCN;
      setState(() {});
    }
  }

  void previousStation() {
    if (stationList.isNotEmpty) {
      if (stationListIndex! > 0) {
        stationListIndex = stationListIndex! - 1;
      } else {
        stationListIndex = stationList.length - 1;
      }
      stationListValue = stationList[stationListIndex!].stationNameCN;
      setState(() {});
    }
  }
}

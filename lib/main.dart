import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/Station.dart';
import 'Util.dart';
import 'Util/CustomPainter.dart';

void main() {
  runApp(const GennokiokuMetroLCDMaker());
}

class GennokiokuMetroLCDMaker extends StatelessWidget {
  const GennokiokuMetroLCDMaker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gennokioku Metro LCD Maker',
      theme: ThemeData(
        tooltipTheme: const TooltipThemeData(
          textStyle: TextStyle(
            color: Colors.white,
            fontFamily: 'GennokiokuLCDFont', // 设置字体样式
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _passedImageKey = GlobalKey();
  Uint8List? _imageBytes;
  List<Station> stations = [];
  String jsonFileName = "";
  Color? lineColor = Colors.transparent;
  Color? lineVariantColor = Colors.transparent;

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

  void _importLineJson() async {
    stations = [];
    List<dynamic> stationsFromJson = [];
    Map<String, dynamic> jsonData;

    // 选择 JSON 文件
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['json'],
      dialogTitle: '选择线路 JSON 文件',
    );
    if (result != null) {
      Uint8List bytes = result.files.single.bytes!;
      try {
        // 读取 JSON 文件内容
        String jsonString = utf8.decode(bytes);
        // 解析 JSON 数据，保存到键值对中
        jsonData = json.decode(jsonString);
        // 将站点保存到集合中
        stationsFromJson = jsonData['stations'];
        // 设置线路颜色和颜色变种
        lineColor = Util.hexToColor(jsonData['lineColor']);
        lineVariantColor = Util.hexToColor(jsonData['lineVariantColor']);
        // 站点不能少于 2
        if (stationsFromJson.length >= 2 && stationsFromJson.length <= 32) {
          // 遍历 JSON 数据，提取站点信息，保存到 stations 集合中
          for (var item in stationsFromJson) {
            Station station = Station(
              stationNameCN: item['stationNameCN'],
              stationNameEN: item['stationNameEN'],
            );
            stations.add(station);
          }
          // 刷新页面状态
          setState(() {});
        } else if (stationsFromJson.length < 2) {
          showAlertDialog("错误", "站点数量不能小于 2");
        } else if (stationsFromJson.length > 32) {
          showAlertDialog("错误", "直线型线路图站点数量不能大于 32，请使用 U 形线路图");
        }
      } catch (e) {
        print('读取文件失败: $e');
        showAlertDialog("错误", "选择的文件格式错误，或文件内容格式未遵循规范");
      }
    }
  }

  void showAlertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: const TextStyle(fontFamily: "GennokiokuLCDFont")),
            content: Text(content,
                style: const TextStyle(fontFamily: "GennokiokuLCDFont")),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("好",
                    style: TextStyle(fontFamily: "GennokiokuLCDFont")),
              )
            ],
          );
        });
  }

  Future<void> _exportImage() async {
    try {
      RenderRepaintBoundary boundary = _mainImageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.5);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String? saveFile = await FilePicker.platform.saveFile(
          dialogTitle: "Select saving folder",
          fileName: "运行中 + 站名.png",
          type: FileType.image,
          allowedExtensions: ["PNG"]);
      final String path = '$saveFile';
      File imgFile = File(path);

      if (path != "null") {
        await imgFile.writeAsBytes(pngBytes);
        showAlertDialog("图片已导出", "图片已成功保存至: $path");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("取消导出"),
        ));
      }
    } catch (e) {
      print('导出图片失败: $e');
    }
  }

  Future<void> _exportPassedImage() async {
    try {
      RenderRepaintBoundary boundary = _passedImageKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.5);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String? saveFile = await FilePicker.platform.saveFile(
          dialogTitle: "Select saving folder",
          fileName: "运行中 + 站名.png",
          type: FileType.image,
          allowedExtensions: ["PNG"]);
      final String path = '$saveFile';
      File imgFile = File(path);

      if (path != "null") {
        await imgFile.writeAsBytes(pngBytes);
        showAlertDialog("图片已导出", "图片已成功保存至: $path");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("取消导出"),
        ));
      }
    } catch (e) {
      print('导出图片失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('原忆轨道交通 LCD 生成器',
            style: TextStyle(fontFamily: "GennokiokuLCDFont")),
        elevation: 4,
      ),
      body: Column(
        children: [
          Row(
            children: [
              MenuBar(children: [
                MenuItemButton(
                  onPressed: _importImage,
                  child: const Text(
                    "导入图片",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                MenuItemButton(
                  onPressed: _importLineJson,
                  child: const Text(
                    "导入站名",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                MenuItemButton(
                  onPressed: _exportImage,
                  child: const Text(
                    "导出主线路图",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                MenuItemButton(
                  onPressed: _exportPassedImage,
                  child: const Text(
                    "导出已过站图",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                Text(
                  "下一站",
                  style: TextStyle(
                      fontFamily: "GennokiokuLCDFont", color: Colors.black),
                ),
                DropdownButton(
                    items: showNextStationList(stations),
                    onChanged: null,
                    value: null)
              ]),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                RepaintBoundary(
                  key: _mainImageKey,
                  child: SizedBox(
                    height: 340,
                    child: Stack(
                      children: [
                        _imageBytes != null
                            ? Image.memory(
                                _imageBytes!,
                              )
                            : const SizedBox(),
                        Container(
                          padding: EdgeInsets.fromLTRB(22, 15.5, 0, 0),
                          child: Image.asset(
                            "assets/image/gennokioku_railway_transit_logo.png",
                            scale: 1.5,
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(521, 8, 0, 0),
                            child: Text(
                              "下一站",
                              style: TextStyle(
                                  fontSize: 28, fontFamily: "GennokiokuLCDFont"
                                  //fontWeight: FontWeight.bold,
                                  ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(524, 41, 0, 0),
                            child: Text(
                              "Next station",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "GennokiokuLCDFont"
                                  //fontWeight: FontWeight.bold,
                                  ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(909, 8, 0, 0),
                            child: Text(
                              "终点站",
                              style: TextStyle(
                                  fontSize: 28, fontFamily: "GennokiokuLCDFont"
                                  //fontWeight: FontWeight.bold,
                                  ),
                            )),
                        Container(
                            padding: EdgeInsets.fromLTRB(922, 41, 0, 0),
                            child: Text(
                              "Terminus",
                              style: TextStyle(
                                  fontSize: 14, fontFamily: "GennokiokuLCDFont"
                                  //fontWeight: FontWeight.bold,
                                  ),
                            )),
                        Container(
                          padding: const EdgeInsets.fromLTRB(190, 165, 0, 0),
                          child: showStationName(stations),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(190, 195, 0, 0),
                          child: showRouteLine(lineColor!),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                          child: showRouteIcon(stations),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
                //已过站图
                RepaintBoundary(
                  key: _passedImageKey,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 334,
                      ), //调好的尺寸，正好能占位500高度
                      Container(
                        padding: const EdgeInsets.fromLTRB(190, 195, 0, 0),
                        child: showRouteLine(Util.hexToColor("89898A")),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                        child: showPassedRouteIcon(stations),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imageBytes = null;
          stations = [];
          lineColor = Colors.transparent;
          lineVariantColor = Colors.transparent;
          setState(() {});
        },
        tooltip: '重置',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<DropdownMenuItem> showNextStationList(List<Station> stations) {
    List<DropdownMenuItem> tempList = [];
    for (var value in stations) {
      value.stationNameCN;
      tempList.add(DropdownMenuItem(
        child: Text(
          value.stationNameCN,
          style: TextStyle(fontFamily: "GennokiokuLCDFont"),
        ),
        value: value.stationNameCN,
      ));
    }
    return tempList;
  }

  //显示线路中线
  Container showRouteLine(Color color) {
    return Container(
      width: 1400,
      height: 15,
      color: color,
    );
  }

  //显示站点图标
  Stack showRouteIcon(List<Station> station) {
    List<Container> tempList = [];
    for (int i = 0; i < station.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (station.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: StationIconPainter(
                lineColor: lineColor, lineVariantColor: lineVariantColor),
          )));
    }
    return Stack(
      children: tempList,
    );
  }

  Stack showPassedRouteIcon(List<Station> station) {
    List<Container> tempList = [];
    for (int i = 0; i < station.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (station.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: StationIconPainter(
                lineColor: Util.hexToColor("89898A"),
                lineVariantColor: Util.hexToColor("9E9E9F")),
          )));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示站名
  Stack showStationName(List<Station> station) {
    //TODO 文字大小随窗口改变适应
    List<Container> tempList = [];
    double count = 0;
    for (var value in station) {
      tempList.add(Container(
        padding:
            EdgeInsets.fromLTRB((1400 / (station.length - 1)) * count, 0, 0, 0),
        child: Container(
          //逆时针45度
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameCN,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: "GennokiokuLCDFont",
              color: Colors.black,
            ),
          ),
        ),
      ));
      tempList.add(Container(
        padding: EdgeInsets.fromLTRB(
            //英文站名做适当偏移
            15 + (1400 / (station.length - 1)) * count,
            10,
            0,
            0),
        child: Container(
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameEN,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: "GennokiokuLCDFont",
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
}

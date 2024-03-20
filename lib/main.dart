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
  String? nextStationListValue;
  int? nextStationListIndex;
  String? terminusListValue;
  int? terminusListIndex;
  String backgroundColor = "c8c9ca";

  // String checkNullIndex(int index) {
  //   return index == 0 ? "" : stations[index].stationNameCN;
  // }

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
      //尝试读取文件
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
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stations.clear();
          nextStationListIndex = 0; //会导致显示的是前一个索引对应的站点
          terminusListIndex = 0;

          // 遍历 JSON 数据，提取站点信息，保存到 stations 集合中
          for (dynamic item in stationsFromJson) {
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
      nextStationListValue = stations[0].stationNameCN;
      terminusListValue = stations[0].stationNameCN;
    }
  }

  void exportMainImage() {
    exportImage(_mainImageKey, "保存",
        "运行中 $nextStationListValue, $terminusListValue方向.png");
  }

  void exportPassedImage() {
    exportImage(_passedImageKey, "保存", "已过站.png");
  }

  Future<void> exportImage(
      GlobalKey key, String dialogTitle, String fileName) async {
    try {
      //获取 stack
      RenderBox findRenderObject =
          key.currentContext?.findRenderObject() as RenderBox;

      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio:
              2560 / findRenderObject.size.width); //确保导出的图片宽高固定为2560*500
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      String? saveFile = await FilePicker.platform.saveFile(
          dialogTitle: dialogTitle,
          fileName: fileName,
          type: FileType.image,
          allowedExtensions: ["PNG"]);
      final String path = '$saveFile';
      File imgFile = File(path);

      if (path != "null") {
        await imgFile.writeAsBytes(pngBytes);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("图片已成功保存至: $path",
              style: const TextStyle(fontFamily: "GennokiokuLCDFont")),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("取消导出", style: TextStyle(fontFamily: "GennokiokuLCDFont")),
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
                SizedBox(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: _importImage,
                    child: const Text(
                      "导入图片",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: _importLineJson,
                    child: const Text(
                      "导入站名",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportMainImage,
                    child: const Text(
                      "导出主线路图",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportPassedImage,
                    child: const Text(
                      "导出已过站图",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text(
                    "下一站",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "下一站",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont",
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                  items: showNextStationList(),
                  onChanged: (value) {
                    nextStationListIndex = stations.indexWhere(
                        (element) => element.stationNameCN == value);
                    nextStationListValue = value;
                    setState(() {});
                  },
                  value: nextStationListValue,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  child: const Text(
                    "终点站",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                DropdownButton(
                  disabledHint: const Text(
                    "终点站",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont",
                        color: Colors.grey,
                        fontSize: 14),
                  ),
                  items: showNextStationList(),
                  onChanged: (value) {
                    terminusListIndex = stations.indexWhere(
                        (element) => element.stationNameCN == value);
                    terminusListValue = value;
                    setState(() {});
                  },
                  value: terminusListValue,
                )
              ]),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      RepaintBoundary(
                        key: _mainImageKey,
                        child: Container(
                          color: Util.hexToColor(backgroundColor),
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: 1715.2,
                                height: 335,
                              ),
                              _imageBytes != null
                                  ? Image.memory(
                                      _imageBytes!,
                                    )
                                  : const SizedBox(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 15.5, 0, 0),
                                child: Image.asset(
                                  "assets/image/gennokioku_railway_transit_logo.png",
                                  scale: 1.5,
                                ),
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(521, 8, 0, 0),
                                  child: const Text(
                                    "下一站",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(524, 41, 0, 0),
                                  child: const Text(
                                    "Next station",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(909, 8, 0, 0),
                                  child: const Text(
                                    "终点站",
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(922, 41, 0, 0),
                                  child: const Text(
                                    "Terminus",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(617, 8, 0, 0),
                                  child: Text(
                                    nextStationListIndex == null
                                        ? ""
                                        : stations[nextStationListIndex!]
                                            .stationNameCN,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(1007, 8, 0, 0),
                                  child: Text(
                                    terminusListIndex == null
                                        ? ""
                                        : stations[terminusListIndex!]
                                            .stationNameCN,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(617, 41, 0, 0),
                                  child: Text(
                                    nextStationListIndex == null
                                        ? ""
                                        : stations[nextStationListIndex!]
                                            .stationNameEN,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(1007, 41, 0, 0),
                                  child: Text(
                                    terminusListIndex == null
                                        ? ""
                                        : stations[terminusListIndex!]
                                            .stationNameEN,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 165, 0, 0),
                                child: showStationName(),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 195, 0, 0),
                                child: showRouteLine(lineColor!),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                child: showRouteIcon(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(),
                      //已过站图
                      RepaintBoundary(
                        key: _passedImageKey,
                        child: Container(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: 1715.2,
                                height: 335,
                              ), //调好的尺寸，正好能占位500高度
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 195, 0, 0),
                                child: showRouteLine(Util.hexToColor("89898A")),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                child: showPassedRouteIcon(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imageBytes = null;
          stations.clear();
          lineColor = Colors.transparent;
          lineVariantColor = Colors.transparent;
          nextStationListIndex = null;
          terminusListIndex = null;
          nextStationListValue = null;
          terminusListValue = null;
          setState(() {});
        },
        tooltip: '重置',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  List<DropdownMenuItem> showNextStationList() {
    List<DropdownMenuItem> tempList = [];
    for (Station value in stations) {
      value.stationNameCN;
      tempList.add(DropdownMenuItem(
        child: Text(
          value.stationNameCN,
          style: const TextStyle(fontFamily: "GennokiokuLCDFont"),
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
  Stack showRouteIcon() {
    List<Container> tempList = [];
    for (int i = 0; i < stations.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stations.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: StationIconPainter(
                lineColor: lineColor, lineVariantColor: lineVariantColor),
          )));
    }
    return Stack(
      children: tempList,
    );
  }

  Stack showPassedRouteIcon() {
    List<Container> tempList = [];
    for (int i = 0; i < stations.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stations.length - 1)) * i, 0, 0, 0),
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
  Stack showStationName() {
    //TODO 文字大小随窗口改变适应
    List<Container> tempList = [];
    double count = 0;
    for (Station value in stations) {
      tempList.add(Container(
        padding: EdgeInsets.fromLTRB(
            (1400 / (stations.length - 1)) * count, 0, 0, 0),
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
            15 + (1400 / (stations.length - 1)) * count,
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
}

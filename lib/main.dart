import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:main/Object/Station.dart';
import 'Util.dart';
import 'Util/CustomColors.dart';
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
      scrollBehavior: CustomScrollBehavior(), //设置鼠标拖动滑动
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();
  final GlobalKey _passedIconImageKey = GlobalKey();
  final GlobalKey _passedLineImageKey = GlobalKey();
  final GlobalKey _passingImageKey = GlobalKey();
  final GlobalKey _shadowImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //站名集合
  List<Station> stations = [];

  //线路颜色和颜色变体，默认透明，导入文件时赋值
  Color? lineColor = Colors.transparent;
  Color? lineVariantColor = Colors.transparent;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? nextStationListValue;
  String? terminusListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? nextStationListIndex;
  int? terminusListIndex;

  //TODO:导入背景图片，待完整复刻样式后删除
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
        // 将站点保存到临时集合中
        stationsFromJson = jsonData['stations'];
        // 设置线路颜色和颜色变体
        lineColor = Util.hexToColor(jsonData['lineColor']);
        lineVariantColor = Util.hexToColor(jsonData['lineVariantColor']);
        // 站点不能少于 2 或大于 32
        if (stationsFromJson.length >= 2 && stationsFromJson.length <= 32) {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stations.clear();
          nextStationListIndex = 0; //会导致显示的是前一个索引对应的站点
          terminusListIndex = 0;

          // 遍历临时集合，获取站点信息，保存到 stations 集合中
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
      //文件成功导入后将下拉菜单默认值设为第一站
      nextStationListValue = stations[0].stationNameCN;
      terminusListValue = stations[0].stationNameCN;
    }
  }

  //导出主线路图
  void exportMainImage() {
    exportImage(_mainImageKey, "保存",
        "运行中 $nextStationListValue, $terminusListValue方向.png");
  }

  //导出已过站点图
  void exportPassedIconImage() {
    exportImage(_passedIconImageKey, "保存", "已过站点.png");
  }

  //导出已过站线图
  void exportPassedLineImage() {
    exportImage(_passedLineImageKey, "保存", "已过站线.png");
  }
  //导出下一站图
  void exportPassingImage() {
    exportImage(_passingImageKey, "保存", "下一站 $nextStationListValue.png");
  }

  //导出阴影图
  void exportShadowImage() {
    exportImage(_shadowImageKey, "保存", "阴影.png");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('直线型线路图 运行中',
            style: TextStyle(fontFamily: "GennokiokuLCDFont")),
        elevation: 4,
      ),
      body: Column(
        children: [
          Row(
            children: [
              MenuBar(children: [
                SizedBox(
                  height: 48, //确保顶部功能行在站名下拉菜单加载时高度不变
                  child: MenuItemButton(
                    onPressed: _importImage,
                    child: const Text(
                      "导入图片",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
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
                SizedBox(
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
                SizedBox(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportPassedLineImage,
                    child: const Text(
                      "导出已过站线图",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportPassedIconImage,
                    child: const Text(
                      "导出已过站点图",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportPassingImage,
                    child: const Text(
                      "导出下一站图",
                      style: TextStyle(
                          fontFamily: "GennokiokuLCDFont", color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: MenuItemButton(
                    onPressed: exportShadowImage,
                    child: const Text(
                      "导出阴影图",
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
                  ), //设置空时的提示文字
                  items: showStationList(),
                  onChanged: (value) {
                    nextStationListIndex = stations.indexWhere((element) =>
                        element.stationNameCN == value); //根据选择的站名，找到站名集合中对应的索引
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
                  items: showStationList(),
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
                  scrollDirection: Axis.horizontal, //设置可水平、竖直滑动
                  child: Column(
                    children: [
                      //主线路图
                      RepaintBoundary(
                        key: _mainImageKey,
                        child: Container(
                          color: Util.hexToColor(CustomColors.backgroundColor),
                          child: Stack(
                            children: [
                              const SizedBox(
                                //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
                                width: 1715.2,
                                height: 334.5,
                              ),
                              _imageBytes != null
                                  ? SizedBox(
                                      height: 334.5,
                                      child: Image.memory(
                                        _imageBytes!,
                                      ),
                                    )
                                  : const SizedBox(),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(22, 15.5, 0, 0),
                                child: Image.asset(
                                  "assets/image/gennokioku_railway_transit_logo.png",
                                  scale: 1.5,
                                ),
                              ), //TODO:图片logo换为svg等方式绘制，避免模糊
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
                                      const EdgeInsets.fromLTRB(525, 41, 0, 0),
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
                                      const EdgeInsets.fromLTRB(910, 8, 0, 0),
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
                                      const EdgeInsets.fromLTRB(924, 41, 0, 0),
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
                                      const EdgeInsets.fromLTRB(618, 8, 0, 0),
                                  child: Text(
                                    nextStationListIndex == null
                                        ? ""
                                        : stations[nextStationListIndex!]
                                            .stationNameCN,
                                    //默认时索引为空，不显示站名；不为空时根据索引对应站名显示
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: "GennokiokuLCDFont"
                                        //fontWeight: FontWeight.bold,
                                        ),
                                  )),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(1009, 8, 0, 0),
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
                                      const EdgeInsets.fromLTRB(618, 41, 0, 0),
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
                                      const EdgeInsets.fromLTRB(1009, 41, 0, 0),
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
                      //已过站点图
                      RepaintBoundary(
                        key: _passedIconImageKey,
                        child: Container(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: 1715.2,
                                height: 334.5,
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
                      //已过站线图
                      RepaintBoundary(
                        key: _passedLineImageKey,
                        child: Container(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: 1715.2,
                                height: 334.5,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 195, 0, 0),
                                child: showRouteLine(Util.hexToColor(
                                    CustomColors.passedStation)),
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
                                width: 1715.2,
                                height: 334.5,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                child: showPassingRouteIcon(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //阴影图
                      RepaintBoundary(
                        key: _shadowImageKey,
                        child: Container(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              const SizedBox(
                                width: 1715.2,
                                height: 334.5,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(190, 202.5, 0, 0),
                                child: showShadowIcon(),
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

  //显示下一站/终点站下拉菜单内容
  List<DropdownMenuItem> showStationList() {
    List<DropdownMenuItem> tempList = [];
    for (Station value in stations) {
      value.stationNameCN;
      tempList.add(DropdownMenuItem(
        value: value.stationNameCN,
        child: Text(
          value.stationNameCN,
          style: const TextStyle(fontFamily: "GennokiokuLCDFont"),
        ),
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

  //显示已过站图标
  Stack showPassedRouteIcon() {
    //TODO:根据选择的下一站动态显示已过站，需要考虑小交线时，下一站在终点站前后，在前则下一站前和终点站后已过；在后则下一站后和终点站前已过（考虑小交线时已经包括了跑全程的情况，因为全程时，终点站前后不会有其他站）
    List<Container> tempList = [];
    for (int i = 0; i < stations.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stations.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
            painter: StationIconPainter(
                lineColor: Util.hexToColor(CustomColors.passedStation),
                lineVariantColor:
                    Util.hexToColor(CustomColors.passedStationVariant)),
          )));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示正在过站图标
  Stack showPassingRouteIcon() {
    List<Container> tempList = [];
    if (nextStationListIndex!=null) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stations.length - 1)) * nextStationListIndex!, 0, 0, 0),
          child: CustomPaint(
              painter: StationIconPainter(
                lineColor: Util.hexToColor(CustomColors.passingStation),
                lineVariantColor:
                Util.hexToColor(CustomColors.passingStationVariant),
              ))));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示阴影
  Stack showShadowIcon() {
    List<Container> tempList = [];
    for (int i = 0; i < stations.length; i++) {
      tempList.add(Container(
          padding: EdgeInsets.fromLTRB(
              10 + (1400 / (stations.length - 1)) * i, 0, 0, 0),
          child: CustomPaint(
              painter: ShadowIconPainter(
            lineColor: lineColor,
            lineVariantColor: lineVariantColor,
          ))));
    }
    return Stack(
      children: tempList,
    );
  }

  //显示站名
  Stack showStationName() {
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

  //通用提示对话框方法
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

  //通用导出方法
  Future<void> exportImage(
      GlobalKey key, String dialogTitle, String fileName) async {
    try {
      //获取 key 对应的 stack 用于获取宽度
      RenderBox findRenderObject =
          key.currentContext!.findRenderObject() as RenderBox;

      //获取 key 对应的 stack 用于获取图片
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
        //路径有效，保存
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
}

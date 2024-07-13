// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Util.dart';
import '../../../../Util/CustomColors.dart';
import '../../../Parent/RailwayTransit/StationEntrance.dart';
import '../../../Preference.dart';

class OperationDirectionRoot extends StatelessWidget {
  const OperationDirectionRoot({super.key});

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
      home: const OperationDirection(),
    );
  }
}

class OperationDirection extends StatefulWidget {
  const OperationDirection({super.key});

  @override
  OperationDirectionState createState() => OperationDirectionState();
}

class OperationDirectionState extends State<OperationDirection>
    with StationEntrance {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 240;
  static const double imageWidth = 1440;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  static String lineColor = "FF0000"; //线路标识色
  String tempLineColor = lineColor; //线路标识色

  //线路编号、站名控制器
  TextEditingController lineNumberController = TextEditingController();
  TextEditingController stationNameLeftController =
      TextEditingController(text: "往 ");
  TextEditingController stationNameLeftEnController =
      TextEditingController(text: "To   ");
  TextEditingController stationNameRightController =
      TextEditingController(text: "往 ");
  TextEditingController stationNameRightEnController =
      TextEditingController(text: "To ");

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
                  height: 48,
                  child: MenuItemButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("设置线路标识色"),
                              content: TextField(
                                decoration: InputDecoration(
                                  hintText: lineColor,
                                ),
                                onChanged: (s) {
                                  tempLineColor = s.replaceAll('#', '');
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    try {
                                      Util.hexToColor(tempLineColor);
                                      lineColor = tempLineColor;
                                      setState(() {});
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("颜色格式错误 $e")));
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('确定'),
                                ),
                              ],
                            );
                          });
                    },
                    child: const Text("设置线路标识色"),
                  ),
                )
              ]),
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
                  lineColor = "FF0000";
                  lineNumberController.clear();
                  stationNameLeftController.text = "往 ";
                  stationNameLeftEnController.text = "To   ";
                  stationNameRightController.text = "往 ";
                  stationNameRightEnController.text = "To ";
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
                      CustomColors.railwayTransitGeneralSignBackground),
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
                      Positioned(
                        top: 18.5,
                        child: SvgPicture.string(
                          Util.operationDirectionBody
                              .replaceAll("lineColor", lineColor),
                          width: imageWidth,
                        ),
                      ),
                      Positioned(
                          top: 15,
                          left: 637,
                          child: Container(
                            height: imageHeight,
                            width: imageWidth / 8,
                            child: TextField(
                              controller: lineNumberController,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 120,
                                  fontFamily: "GennokiokuLCDFont",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              decoration: const InputDecoration.collapsed(
                                hintText: "线路编号",
                                hintStyle: TextStyle(
                                    fontSize: 40,
                                    fontFamily: "GennokiokuLCDFont",
                                    color: Colors.grey),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 103,
                          top: 65,
                          child: Container(
                            height: imageHeight,
                            width: imageWidth / 3,
                            child: TextFormField(
                              controller: stationNameLeftController,
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontFamily: "GennokiokuLCDFont",
                                  color: Colors.white),
                              decoration: const InputDecoration.collapsed(
                                hintText: "往 ",
                                hintStyle: TextStyle(
                                    fontSize: 38,
                                    fontFamily: "GennokiokuLCDFont",
                                    color: Colors.grey),
                              ),
                            ),
                          )),
                      Positioned(
                          left: 107,
                          top: 111,
                          child: Container(
                            height: imageHeight,
                            width: imageWidth / 3,
                            child: TextFormField(
                              controller: stationNameLeftEnController,
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontFamily: "GennokiokuLCDFont",
                                  color: Colors.white),
                              decoration: const InputDecoration.collapsed(
                                hintText: "To   ",
                                hintStyle: TextStyle(
                                    fontSize: 23,
                                    fontFamily: "GennokiokuLCDFont",
                                    color: Colors.grey),
                              ),
                            ),
                          )),
                      Positioned(
                          right: 95,
                          top: 91,
                          child: Container(
                            height: imageHeight,
                            width: imageWidth / 3,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              controller: stationNameRightController,
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontFamily: "GennokiokuLCDFont",
                                  color: Colors.white),
                              decoration: const InputDecoration.collapsed(
                                hintText: "往 ",
                                hintStyle: TextStyle(
                                    fontSize: 38,
                                    fontFamily: "GennokiokuLCDFont",
                                    color: Colors.grey),
                              ),
                            ),
                          )),
                      Positioned(
                          right: 95,
                          top: 136,
                          child: Container(
                            height: imageHeight,
                            width: imageWidth / 3,
                            child: TextFormField(
                              textAlign: TextAlign.right,
                              controller: stationNameRightEnController,
                              style: const TextStyle(
                                  fontSize: 23,
                                  fontFamily: "GennokiokuLCDFont",
                                  color: Colors.white),
                              decoration: const InputDecoration.collapsed(
                                hintText: "To ",
                                hintStyle: TextStyle(
                                    fontSize: 23,
                                    fontFamily: "GennokiokuLCDFont",
                                    color: Colors.grey),
                              ),
                            ),
                          ))
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
                  onPressed: _importImage, child: const Text("导入图片")),
            )
          : Container(),
      generalIsDevMode ? const VerticalDivider(thickness: 2) : Container(),
      Container(
        height: 48,
        child: MenuItemButton(
            onPressed: exportMainImage, child: const Text("导出当前图")),
      ),
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

  //导出当前图
  Future<void> exportMainImage() async {
    String fileName =
        "运行方向图 ${lineNumberController.text}号线 ${stationNameLeftController.text.replaceAll("往 ", "")}--${stationNameRightController.text.replaceAll("往 ", "")}.png";
    await exportImage(context, [0], _mainImageKey, fileName, false,
        exportWidthValue: exportWidthValue);
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
}

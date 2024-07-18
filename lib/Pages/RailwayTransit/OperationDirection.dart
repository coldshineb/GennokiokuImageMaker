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

  static String defaultLineColor = "339CD0";
  static String lineColor = defaultLineColor; //线路标识色
  String tempLineColor = lineColor; //线路标识色

  //线路编号、站名控制器
  TextEditingController digitLineNumberController = TextEditingController();
  TextEditingController textLineNumberController = TextEditingController();
  TextEditingController loopLineNumberEnController =
      TextEditingController(text: loopLineNumberEnHint);
  TextEditingController generalStationNameLeftController =
      TextEditingController(text: generalStationNameLeftHint);
  TextEditingController generalStationNameLeftEnController =
      TextEditingController(text: generalStationNameLeftEnHint);
  TextEditingController generalStationNameRightController =
      TextEditingController(text: generalStationNameRightHint);
  TextEditingController generalStationNameRightEnController =
      TextEditingController(text: generalStationNameRightEnHint);
  TextEditingController loopStationNameLeftController =
      TextEditingController(text: loopStationNameLeftHint);
  TextEditingController loopStationNameLeftEnController =
      TextEditingController(text: loopStationNameLeftEnHint);
  TextEditingController loopStationNameLeftEnSecondController =
      TextEditingController();
  TextEditingController loopStationNameRightController =
      TextEditingController(text: loopStationNameRightHint);
  TextEditingController loopStationNameRightEnController =
      TextEditingController(text: loopStationNameRightEnHint);
  TextEditingController loopStationNameRightEnSecondController =
      TextEditingController();

  int lineType = 0; //线路类型
  int lineNumberType = 0; //线路名称类型

  //线路名称提示
  static String loopLineNumberEnHint = "Line ";
  static String generalStationNameLeftHint = "往 ";
  static String generalStationNameLeftEnHint = "To   ";
  static String generalStationNameRightHint = "往 ";
  static String generalStationNameRightEnHint = "To ";
  static String loopStationNameLeftHint = "经 ";
  static String loopStationNameLeftEnHint = "Via  ";
  static String loopStationNameRightHint = "经 ";
  static String loopStationNameRightEnHint = "Via ";

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
              MenuBar(
                style: menuStyle(context),
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 14, left: 7),
                    height: 48,
                    child: const Text("纪念版，不要在生产环境使用",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
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
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  height: 48,
                  child: const Text("线路类型"),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                    groupValue: lineType,
                    onChanged: (value) {
                      setState(() {
                        lineType = value!;
                      });
                    },
                    value: 0,
                    child: const Text("一般线路"),
                  ),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                    groupValue: lineType,
                    onChanged: (value) {
                      setState(() {
                        lineType = value!;
                      });
                    },
                    value: 1,
                    child: const Text("环线"),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 14),
                  height: 48,
                  child: const Text("线路名称类型"),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                    groupValue: lineNumberType,
                    onChanged: (value) {
                      setState(() {
                        lineNumberType = value!;
                      });
                    },
                    value: 0,
                    child: const Text("数字"),
                  ),
                ),
                Container(
                  height: 48,
                  child: RadioMenuButton(
                    groupValue: lineNumberType,
                    onChanged: (value) {
                      setState(() {
                        lineNumberType = value!;
                      });
                    },
                    value: 1,
                    child: const Text("文字"),
                  ),
                ),
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
                  lineColor = defaultLineColor;
                  digitLineNumberController.clear();
                  textLineNumberController.clear();
                  loopLineNumberEnController.text = loopLineNumberEnHint;
                  generalStationNameLeftController.text =
                      generalStationNameLeftHint;
                  generalStationNameLeftEnController.text =
                      generalStationNameLeftEnHint;
                  generalStationNameRightController.text =
                      generalStationNameRightHint;
                  generalStationNameRightEnController.text =
                      generalStationNameRightEnHint;
                  loopStationNameLeftController.text = loopStationNameLeftHint;
                  loopStationNameLeftEnController.text =
                      loopStationNameLeftEnHint;
                  loopStationNameLeftEnSecondController.clear();
                  loopStationNameRightController.text =
                      loopStationNameRightHint;
                  loopStationNameRightEnController.text =
                      loopStationNameRightEnHint;
                  loopStationNameRightEnSecondController.clear();
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
                      operationDirectionBody(),
                      lineName(),
                      stationName()
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  //线路名称
  Container lineName() {
    return lineNumberType == 0
        ? Container(
            height: imageHeight,
            width: imageWidth,
            child: Stack(
              children: [
                Positioned(
                    left: imageWidth / 2 - 201,
                    top: 85,
                    child: Container(
                      child: const Text(
                        "LINE",
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                      ),
                    )),
                Positioned(
                    left: imageWidth / 2 + 101,
                    top: 85,
                    child: Container(
                      child: const Text(
                        "号线",
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                      ),
                    )),
                Positioned(
                    top: 20,
                    left: 630,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 8,
                      child: TextField(
                        controller: digitLineNumberController,
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
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ))
              ],
            ),
          )
        : Container(
            height: imageHeight,
            width: imageWidth,
            child: Stack(
              children: [
                Positioned(
                    top: 67,
                    left: 541,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 4,
                      child: TextField(
                        controller: textLineNumberController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 45,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: "线路编号",
                          hintStyle: TextStyle(
                              fontSize: 45,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    )),
                Positioned(
                    top: 121,
                    left: 632,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 8,
                      child: TextField(
                        controller: loopLineNumberEnController,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 36,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: "Line Number",
                          hintStyle: TextStyle(
                              fontSize: 25,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    ))
              ],
            ),
          );
  }

  //运行方向主体
  Positioned operationDirectionBody() {
    return lineType == 0
        ? Positioned(
            top: 18.5,
            child: SvgPicture.string(
              Util.operationDirectionBody.replaceAll("lineColor", lineColor),
              width: imageWidth,
            ),
          )
        : Positioned(
            left: 55,
            top: 22,
            child: SvgPicture.string(
              Util.operationDirectionBodyLoop
                  .replaceAll("lineColor", lineColor),
              width: imageWidth - 110,
            ),
          );
  }

  //站名
  Container stationName() {
    return lineType == 0
        ? Container(
            height: imageHeight,
            width: imageWidth,
            child: Stack(
              children: [
                Positioned(
                    left: 103,
                    top: 65,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        controller: generalStationNameLeftController,
                        style: const TextStyle(
                            fontSize: 38,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: generalStationNameLeftHint,
                          hintStyle: const TextStyle(
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
                      child: TextField(
                        controller: generalStationNameLeftEnController,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: generalStationNameLeftEnHint,
                          hintStyle: const TextStyle(
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
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: generalStationNameRightController,
                        style: const TextStyle(
                            fontSize: 38,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: generalStationNameRightHint,
                          hintStyle: const TextStyle(
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
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: generalStationNameRightEnController,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: generalStationNameRightEnHint,
                          hintStyle: const TextStyle(
                              fontSize: 23,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    ))
              ],
            ),
          )
        : Container(
            height: imageHeight,
            width: imageWidth,
            child: Stack(
              children: [
                Positioned(
                    left: 186,
                    top: 78,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        controller: loopStationNameLeftController,
                        style: const TextStyle(
                            fontSize: 38,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: loopStationNameLeftHint,
                          hintStyle: const TextStyle(
                              fontSize: 38,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    )),
                Positioned(
                    left: 191,
                    top: 124,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        controller: loopStationNameLeftEnController,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: loopStationNameLeftEnHint,
                          hintStyle: const TextStyle(
                              fontSize: 23,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    )),
                //站名左侧英文第二行
                Positioned(
                    left: 235,
                    top: 149,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        controller: loopStationNameLeftEnSecondController,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: "",
                        ),
                      ),
                    )),
                Positioned(
                    right: 186,
                    top: 78,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: loopStationNameRightController,
                        style: const TextStyle(
                            fontSize: 38,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: loopStationNameRightHint,
                          hintStyle: const TextStyle(
                              fontSize: 38,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    )),
                Positioned(
                    right: 191,
                    top: 124,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        textAlign: TextAlign.right,
                        controller: loopStationNameRightEnController,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: InputDecoration.collapsed(
                          hintText: loopStationNameRightEnHint,
                          hintStyle: const TextStyle(
                              fontSize: 23,
                              fontFamily: "GennokiokuLCDFont",
                              color: Colors.grey),
                        ),
                      ),
                    )),
                //站名右侧英文第二行
                Positioned(
                    right: 191,
                    top: 149,
                    child: Container(
                      height: imageHeight,
                      width: imageWidth / 3,
                      child: TextField(
                        controller: loopStationNameRightEnSecondController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 23,
                            fontFamily: "GennokiokuLCDFont",
                            color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: "",
                        ),
                      ),
                    ))
              ],
            ),
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
            onPressed: exportMainImage, child: const Text("导出图片")),
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
        "运行方向图 ${lineNumberType == 0 ? "${digitLineNumberController.text}号线" : textLineNumberController.text} ${lineType == 0 ? "${generalStationNameLeftController.text.replaceAll(generalStationNameLeftHint, "")}--${generalStationNameRightController.text.replaceAll(generalStationNameRightHint, "")}" : "${loopStationNameLeftController.text.replaceAll(loopStationNameLeftHint, "").replaceAll(loopStationNameRightHint, "")}--${loopStationNameRightController.text.replaceAll(loopStationNameRightHint, "").replaceAll(loopStationNameLeftHint, "")}"}.png";
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

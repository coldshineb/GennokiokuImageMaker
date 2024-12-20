// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Object/Line.dart';
import '../../../../Object/Station.dart';
import '../../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../../Parent/ImageMaker/RailwayTransit/LCD.dart';
import '../../../../Preference.dart';
import '../../../../Util.dart';
import '../../../../Util/CustomColors.dart';
import '../../../../Util/Widgets.dart';

class ArrivalStationInfoRoot extends StatelessWidget {
  const ArrivalStationInfoRoot({super.key});

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
      home: const ArrivalStationInfo(),
    );
  }
}

class ArrivalStationInfo extends StatefulWidget {
  const ArrivalStationInfo({super.key});

  @override
  ArrivalStationInfoState createState() => ArrivalStationInfoState();
}

class ArrivalStationInfoState extends State<ArrivalStationInfo>
    with LCD, ImageMaker {
  //这两个值是根据整体文字大小等组件调整的，不要动，否则其他组件大小都要跟着改
  static const double imageHeight = 335;
  static const double imageWidth = 1715.2;

  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  //背景图片字节数据
  Uint8List? _imageBytes;

  //背景纹理
  Uint8List? pattern;

  //站名集合
  List<Station> stationList = [];

  //创建换乘线路列表的列表
  List<List<Line>> transferLineList = [];

  String lineNumber = "";
  String lineNumberEN = "";

  //线路颜色，默认透明，导入文件时赋值
  Color lineColor = Colors.transparent;
  Color carriageColor = Util.hexToColor("595757");

  int? carriages;
  int? currentCarriage;

  //站名下拉菜单默认值，设空，导入文件时赋值
  String? currentStationListValue;
  String? terminusListValue;

  //站名下拉菜单默认索引，用于找到下拉菜单选择的站名所对应的英文站名，设空，下拉选择站名时赋值
  int? currentStationListIndex;
  int? terminusListIndex;

  //运行方向，用于处理已到站与终点站为中间某一站时的线条显示，0为向左行，1为向右行
  int trainDirectionValue = 1;

  //是否显示原忆轨道交通品牌图标
  bool showLogo = true;

  //是否显示出入口编号
  bool showEntrance = true;

  //默认导出宽度
  int exportWidthValue = 2560;

  late Map<String, dynamic> jsonData;

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
                    child: const Text("运行方向"),
                  ),
                  Container(
                    height: 48,
                    child: RadioMenuButton(
                        value: 0,
                        groupValue: trainDirectionValue,
                        onChanged: (v) {
                          setState(() {
                            trainDirectionValue = v!;
                          });
                        },
                        child: const Text("向左行")),
                  ),
                  Container(
                    height: 48,
                    child: RadioMenuButton(
                        value: 1,
                        groupValue: trainDirectionValue,
                        onChanged: (v) {
                          setState(() {
                            trainDirectionValue = v!;
                          });
                        },
                        child: const Text("向右行")),
                  )
                ]),
                MenuBar(style: menuStyle(context), children: [
                  Container(
                    padding: const EdgeInsets.only(top: 14, left: 7),
                    child: const Text("当前站"),
                  ),
                  DropdownButton(
                    disabledHint: const Text(
                      "当前站",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ), //设置空时的提示文字
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        int indexWhere = stationList.indexWhere(
                            (element) => element.stationNameCN == value);
                        indexWhere;
                        if (indexWhere == 2) {
                          trainDirectionValue = 0;
                        } else if (indexWhere == stationList.length - 3) {
                          trainDirectionValue = 1;
                        }
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
                  Container(
                    padding: const EdgeInsets.only(top: 14),
                    child: const Text("终点站"),
                  ),
                  DropdownButton(
                    disabledHint: const Text(
                      "终点站",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    items: showStationList(stationList),
                    onChanged: (value) {
                      try {
                        int indexWhere = stationList.indexWhere(
                            (element) => element.stationNameCN == value);
                        indexWhere;
                        if (indexWhere == 2) {
                          trainDirectionValue = 0;
                        } else if (indexWhere == stationList.length - 3) {
                          trainDirectionValue = 1;
                        }
                        terminusListIndex = indexWhere;
                        terminusListValue = value;
                        setState(() {});
                      } catch (e) {
                        print(e);
                      }
                    },
                    value: terminusListValue,
                  ),
                  Container(
                    height: 48,
                    child: MenuItemButton(
                      onPressed: previousStation,
                      child: const Text("上一站"),
                    ),
                  ),
                  Container(
                    height: 48,
                    child: MenuItemButton(
                      onPressed: nextStation,
                      child: const Text("下一站"),
                    ),
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
                    pattern = null;
                    stationList.clear();
                    transferLineList.clear();
                    lineColor = Colors.transparent;
                    currentStationListIndex = null;
                    terminusListIndex = null;
                    currentStationListValue = null;
                    terminusListValue = null;
                    lineNumber = "";
                    lineNumberEN = "";
                    carriages = null;
                    currentCarriage = null;
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
                  color:
                      Util.hexToColor(CustomColors.railwayTransitLCDBackground),
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
                      backgroundPattern(),
                      gennokiokuRailwayTransitLogoWidget(showLogo),
                      lineNumberIconWidget(lineColor, lineNumber, lineNumberEN),
                      Container(
                        height: imageHeight,
                        width: imageWidth,
                        child: topLabels(
                            "当前站",
                            "Current station",
                            "终点站",
                            "Terminus",
                            currentStationListIndex,
                            terminusListIndex,
                            stationList),
                      ),
                      arrivalStationInfoBody(),
                      carriage(),
                      hereMark(),
                      directionMarkLeft(),
                      directionMarkRight(),
                      transferFrame(),
                      transferIcon(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Container transferFrame() {
    Container container = Container();
    if (stationList.isNotEmpty &&
        transferLineList[currentStationListIndex!].isNotEmpty) {
      String colorStr = jsonData['lineColor'];
      colorStr = colorStr.replaceAll('#', '');
      String s =
          Util.arrivalStationInfoTransfer.replaceAll("lineColor", colorStr);
      container = Container(
        padding: const EdgeInsets.only(left: 1348, top: 80),
        child: SvgPicture.string(height: 206, width: 206, s),
      );
    }
    return container;
  }

  //显示换乘线路图标
  Container transferIcon() {
    List<Container> tempList = [];
    if (currentStationListIndex != null) {
      List<Line> value = transferLineList[currentStationListIndex!];
      if (value.isNotEmpty) {
        switch (value.length) {
          case 1:
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 60),
              child: transferIconWidget(value, 0),
            ));
            break;
          case 2:
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 30),
              child: transferIconWidget(value, 0),
            ));
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 100),
              child: transferIconWidget(value, 1),
            ));
            break;
          case 3:
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 0),
              child: transferIconWidget(value, 0),
            ));
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 60),
              child: transferIconWidget(value, 1),
            ));
            tempList.add(Container(
              padding: const EdgeInsets.only(top: 120),
              child: transferIconWidget(value, 2),
            ));
            break;
          default:
        }
      }
    }
    return Container(
      padding: const EdgeInsets.only(left: 1535, top: 98),
      child: Stack(
        children: tempList,
      ),
    );
  }

  Transform transferIconWidget(List<Line> value, int index) {
    return Transform.scale(
      scale: 1.27,
      child: Widgets.lineNumberIcon(Util.hexToColor(value[index].lineColor),
          value[index].lineNumber, value[index].lineNumberEN),
    );
  }

  Container directionMarkLeft() {
    Container container = Container();
    if (stationList.isNotEmpty) {
      switch (trainDirectionValue) {
        case 0:
          container = Container(
            padding: const EdgeInsets.only(left: 380, top: 251.5),
            child: SvgPicture.asset(
                height: 22,
                width: 22,
                "assets/image/arrivalStationInfoDirectionToLeft.svg"),
          );
          break;
        case 1:
          container = Container(
            padding: const EdgeInsets.only(left: 380, top: 251.5),
            child: SvgPicture.asset(
                height: 22,
                width: 22,
                "assets/image/arrivalStationInfoDirectionToRight.svg"),
          );
          break;
        default:
      }
    }
    return container;
  }

  Container directionMarkRight() {
    Container container = Container();
    if (stationList.isNotEmpty) {
      switch (trainDirectionValue) {
        case 0:
          container = Container(
            padding: const EdgeInsets.only(left: 1186, top: 251.5),
            child: SvgPicture.asset(
                height: 22,
                width: 22,
                "assets/image/arrivalStationInfoDirectionToLeft.svg"),
          );
          break;
        case 1:
          container = Container(
            padding: const EdgeInsets.only(left: 1186, top: 251.5),
            child: SvgPicture.asset(
                height: 22,
                width: 22,
                "assets/image/arrivalStationInfoDirectionToRight.svg"),
          );
          break;

        default:
      }
    }
    return container;
  }

  Container carriage() {
    List<Container> tempList = [];
    if (carriages != null) {
      for (int i = 1; i < carriages! + 1; i++) {
        tempList.add(Container(
          alignment: Alignment.center,
          height: 61,
          width: (722 - 4 * (carriages! - 1)) / carriages!,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0), color: carriageColor),
          child: Transform.translate(
            offset: const Offset(0, -4),
            child: Text(
              "$i",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 43,
              ),
            ),
          ),
        ));
        tempList.add(Container(
          width: 4,
        ));
      }
      tempList
          .replaceRange(2 * currentCarriage! - 2, 2 * currentCarriage! - 1, [
        Container(
          alignment: Alignment.center,
          height: 61,
          width: (722 - 4 * (carriages! - 1)) / carriages!,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0), color: lineColor),
          child: Transform.translate(
            offset: const Offset(0, -4),
            child: Text(
              "$currentCarriage",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 43,
              ),
            ),
          ),
        )
      ]);
    }
    return Container(
        padding: const EdgeInsets.only(left: 460, top: 184),
        child: Row(children: tempList));
  }

  Container hereMark() {
    Container container = Container();
    if (carriages != null) {
      container = Container(
          padding: EdgeInsets.only(
              left: 457.5 + //初始位置
                  (726 / carriages! - 4) / 2 - //加上图标的一半宽度
                  71 / 2 + //减去当前车厢标识的一半宽度，前三步计算出首个当前车厢标识的位置
                  726 / carriages! * (currentCarriage! - 1), //加上图标的宽度
              top: 251.5),
          child: SvgPicture.asset(
            "assets/image/arrivalStationInfoHere.svg",
            height: 71,
            width: 71,
          ));
    }
    return container;
  }

  Container arrivalStationInfoBody() {
    Container container = Container();
    if (lineColor != Colors.transparent) {
      String bodyToShow = showEntrance
          ? Util.arrivalStationInfoBody
          : Util.arrivalStationInfoBodyWithoutEntrance;
      String colorStr = jsonData['lineColor'];
      colorStr = colorStr.replaceAll('#', '');
      String s = lineColor.computeLuminance() > 0.5
          ? bodyToShow.replaceAll("fontColor", "000000")
          : bodyToShow.replaceAll("fontColor", "ffffff");
      s = s.replaceAll("lineColor", colorStr);
      container = Container(
          padding: const EdgeInsets.fromLTRB(330, 66, 0, 0),
          height: 300,
          width: 1323,
          child: SvgPicture.string(s));
      return container;
    } else {
      return container;
    }
  }

  Container backgroundPattern() {
    return pattern != null
        ? Container(
            height: imageHeight,
            width: imageWidth,
            child: Image.memory(pattern!, repeat: ImageRepeat.repeat))
        : Container();
  }

  @override
  MenuBar importAndExportMenubar() {
    return MenuBar(style: menuStyle(context), children: [
      generalIsDevMode
          ? Container(
              height: 48,
              child: MenuItemButton(
                onPressed: _importImage,
                child: const Text("导入图片"),
              ),
            )
          : Container(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: importLineJson,
          child: const Text("导入线路"),
        ),
      ),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: importPattern,
          child: const Text("导入纹理"),
        ),
      ),
      const VerticalDivider(thickness: 2),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportAllImage,
          child: const Text("导出全部图"),
        ),
      ),
      const VerticalDivider(),
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportMainImage,
          child: const Text("导出主线路图"),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 14),
        child: const Text("导出分辨率"),
      ),
      DropdownButton(
        items: LCD.resolutionList(),
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
            value: showEntrance,
            onChanged: (bool? value) {
              showEntrance = value!;
              setState(() {});
            },
            child: const Text("显示出入口编号"),
          )),
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

  //导入纹理
  @override
  void importPattern() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      withData: true,
      allowedExtensions: ['png'],
      dialogTitle: '选择纹理图片文件',
    );
    if (result != null) {
      Uint8List? bytes = result.files.single.bytes;
      setState(() {
        pattern = bytes;
      });
    }
  }

  //导入线路文件
  @override
  void importLineJson() async {
    List<dynamic> stationsFromJson = [];

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

        int carriagesFromJson = int.parse(jsonData['carriages']);
        int currentCarriageFromJson = int.parse(jsonData['currentCarriage']);

        if (currentCarriageFromJson > carriagesFromJson ||
            currentCarriageFromJson < 1) {
          alertDialog(context, "错误", "当前车厢不在车厢总数范围内");
        } else {
          //清空或重置可能空或导致显示异常的变量，只有文件格式验证无误后才清空
          stationList.clear();
          transferLineList.clear();
          currentStationListIndex = 0; //会导致显示的是前一个索引对应的站点
          terminusListIndex = 0;

          // 设置线路颜色和颜色变体
          lineNumber = jsonData['lineNumber'];
          lineNumberEN = jsonData['lineNumberEN'];
          lineColor = Util.hexToColor(jsonData['lineColor']);
          carriages = carriagesFromJson;
          currentCarriage = currentCarriageFromJson;

          // 遍历临时集合，获取站点信息，保存到 stations 集合中

          for (dynamic item in stationsFromJson) {
            //换乘信息和站点信息分开存，简化代码，显示换乘线路图标时直接读换乘线路列表的列表
            //创建换乘线路列表
            List<Line> transferLines = [];
            //判断是否有换乘信息
            if (item['transfer'] != null) {
              //读取换乘信息并转为换乘线路列表
              List<dynamic> transfers = item['transfer'];
              transferLines = transfers.map((transfer) {
                return Line(transfer['lineNumber'],
                    lineNumberEN: transfer['lineNumberEN'],
                    lineColor: transfer['lineColor']);
              }).toList();
            }
            //添加换乘信息列表到换乘信息列表的列表
            transferLineList.add(transferLines);

            Station station = Station(
              stationNameCN: item['stationNameCN'],
              stationNameEN: item['stationNameEN'],
            );
            stationList.add(station);
          }

          //文件成功导入后将下拉菜单默认值设为第一站
          currentStationListValue = stationList[0].stationNameCN;
          terminusListValue = stationList[stationList.length - 1].stationNameCN;
          terminusListIndex = stationList.length - 1;
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
    if (stationList.isNotEmpty) {
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        if (currentStationListIndex! < terminusListIndex!) {
          for (int i = 0; i < terminusListIndex! + 1; i++) {
            currentStationListIndex = i;
            setState(() {});
            //图片导出有bug，第一轮循环的第一张图不会被刷新状态，因此复制了一遍导出来变相解决bug，实际效果不变
            //断点调试时发现setState后状态并不会立即刷新，而是在第一个exportImage执行后才刷新，因此第一张图不会被刷新状态
            //另一个发现：在断点importImage时发现，setState执行完后不会立即刷新，而是在后面的代码执行完后才刷新
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 站点信息图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 站点信息图 ${currentStationListIndex! + 1} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
          }
        } else if (currentStationListIndex! > terminusListIndex!) {
          for (int i = terminusListIndex!; i < stationList.length; i++) {
            currentStationListIndex = i;
            setState(() {});
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 站点信息图 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
            await exportImage(
                context,
                stationList,
                _mainImageKey,
                "$path${Util.pathSlash}已到站 站点信息图 ${stationList.length - currentStationListIndex!} ${stationList[currentStationListIndex!].stationNameCN}, $terminusListValue方向.png",
                true,
                exportWidthValue: exportWidthValue);
          }
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

  //导出主线路图
  Future<void> exportMainImage() async {
    if (stationList.isNotEmpty) {
      String fileName =
          "已到站 站点信息图 ${currentStationListIndex! + 1} $currentStationListValue, $terminusListValue方向.png";
      await exportImage(context, stationList, _mainImageKey, fileName, false,
          exportWidthValue: exportWidthValue);
    } else {
      noStationsSnackbar(context);
    }
  }

  void nextStation() {
    if (currentStationListIndex == stationList.length - 1 ||
        currentStationListIndex == null) {
      return;
    } else {
      setState(() {
        currentStationListIndex = currentStationListIndex! + 1;
        currentStationListValue =
            stationList[currentStationListIndex!].stationNameCN;
      });
    }
  }

  void previousStation() {
    if (currentStationListIndex == 0 || currentStationListIndex == null) {
      return;
    } else {
      setState(() {
        currentStationListIndex = currentStationListIndex! - 1;
        currentStationListValue =
            stationList[currentStationListIndex!].stationNameCN;
      });
    }
  }
}

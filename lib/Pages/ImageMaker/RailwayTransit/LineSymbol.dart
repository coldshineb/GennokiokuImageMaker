// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import '../../../Parent/ImageMaker/ImageMaker.dart';
import '../../../Preference.dart';
import '../../../Util.dart';
import '../../../Util/Widgets.dart';

class LineSymbolRoot extends StatelessWidget {
  const LineSymbolRoot({super.key});

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
      home: const LineSymbol(),
    );
  }
}

class LineSymbol extends StatefulWidget {
  const LineSymbol({super.key});

  @override
  LineSymbolState createState() => LineSymbolState();
}

class LineSymbolState extends State<LineSymbol> with ImageMaker {
  //用于识别组件的 key
  final GlobalKey _mainImageKey = GlobalKey();

  static String defaultLineNumber = "1";
  static String defaultLineNumberEN = "1";
  static String defaultLineColor = "339CD0";

  static String lineNumber = defaultLineNumber;
  static String lineNumberEN = defaultLineNumberEN;
  static String lineColor = defaultLineColor;
  String tempLineColor = lineColor; //线路标识色

  TextEditingController lineNumberController = TextEditingController();
  TextEditingController lineNumberENController = TextEditingController();
  TextEditingController lineColorController = TextEditingController();

  //默认导出宽度
  int exportHeightValue = 180;

  late bool generalIsScaleEnabled;

  //获取设置项
  void getSetting() {
    generalIsScaleEnabled = Preference.generalIsScaleEnabled;
  }

  @override
  Widget build(BuildContext context) {
    getSetting();
    return Scaffold(
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
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined),
                          const SizedBox(width: 5),
                          const Text("设置线路"),
                        ],
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (
                              BuildContext context,
                            ) {
                              return AlertDialog(
                                title: const Text("设置线路"),
                                content: Container(
                                  height: 200,
                                  child: Column(
                                    children: [
                                      const Text("不符合规范的线路编号将不会显示线路标识"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: lineNumberController,
                                        decoration: const InputDecoration(
                                          labelText: "线路编号",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: lineNumberENController,
                                        decoration: const InputDecoration(
                                          labelText: "线路英文编号",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        controller: lineColorController,
                                        decoration: const InputDecoration(
                                          labelText: "线路标识色",
                                        ),
                                        onChanged: (s) {
                                          tempLineColor = s.replaceAll('#', '');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        try {
                                          lineNumber =
                                              lineNumberController.text;
                                          lineNumberEN =
                                              lineNumberENController.text;
                                          Util.hexToColor(tempLineColor);
                                          lineColor = tempLineColor;
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        } catch (e) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text("错误"),
                                                  content: Text("$e"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text("确定"))
                                                  ],
                                                );
                                              });
                                        }
                                      },
                                      child: const Text("确定"))
                                ],
                              );
                            });
                      }),
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
                  lineNumber = defaultLineNumber;
                  lineNumberEN = defaultLineNumberEN;
                  lineColor = defaultLineColor;
                  lineNumberController.clear();
                  lineNumberENController.clear();
                  lineColorController.clear();
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
              Container(
                padding: const EdgeInsets.all(20),
                child: RepaintBoundary(
                  key: _mainImageKey,
                  child: Container(
                      child: Widgets.lineNumberIcon(Util.hexToColor(lineColor),
                          lineNumber, lineNumberEN)),
                ),
              ),
            ],
          )),
    );
  }

  @override
  MenuBar importAndExportMenubar() {
    return MenuBar(style: menuStyle(context), children: [
      Container(
        height: 48,
        child: MenuItemButton(
          onPressed: exportMainImage,
          child: const Row(children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 5),
            Text("导出图片")
          ]),
        ),
      ),
      Container(
          padding: const EdgeInsets.only(top: 14), child: const Text("导出高度")),
      DropdownButton(
        items: heightList(),
        onChanged: (value) {
          setState(() {
            exportHeightValue = value!;
          });
        },
        value: exportHeightValue,
      ),
    ]);
  }

  //导出高度选择下拉列表
  static List<DropdownMenuItem> heightList() {
    return [
      const DropdownMenuItem(
        value: 180,
        child: Text("180"),
      ),
      const DropdownMenuItem(
        value: 1024,
        child: Text("1024"),
      )
    ];
  }

  //导出当前图
  Future<void> exportMainImage() async {
    String fileName = "线路标识 $lineNumber.png";
    await exportImage(context, [0], _mainImageKey, fileName, false,
        exportHeightValue: exportHeightValue);
  }
}

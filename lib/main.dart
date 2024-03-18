import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:main/station.dart';
import 'dart:math';

void main() {
  runApp(GennokiokuMetroLCDMaker());
}

class GennokiokuMetroLCDMaker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gennokioku Metro LCD Maker',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  GlobalKey _globalKey = GlobalKey();
  File? _imageFile;
  List<Station> stations = [];
  String jsonFileName = "";

  void _pickImage() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
      dialogTitle: '选择背景图片文件',
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.files.single.path!);
      });
    }
  }

  void _importStationName() async {
    stations = [];
    // 用户选择 JSON 文件
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: '选择站名 JSON 文件',
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        // 读取 JSON 文件内容
        String jsonString = await file.readAsString();
        // 解析 JSON 数据
        List<dynamic> jsonList = json.decode(jsonString);
        // 遍历 JSON 数据，提取站点信息

        for (var item in jsonList) {
          Station station = Station(
            stationNameCN: item['stationNameCN'],
            stationNameEN: item['stationNameEN'],
          );
          stations.add(station);
        }
      } catch (e) {
        print('读取文件失败: $e');
      }
      setState(() {});
    }
  }

  Future<void> _exportImage() async {
    if (_imageFile != null) {
      try {
        RenderRepaintBoundary boundary = _globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 1.5);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        var saveFile = await FilePicker.platform.saveFile(
            dialogTitle: "Select saving folder",
            fileName: "运行中 + 站名.png",
            type: FileType.image,
            allowedExtensions: ["PNG"]);
        final String path = '$saveFile';
        File imgFile = File(path);
        if (path != "null") {
          await imgFile.writeAsBytes(pngBytes);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('图片已导出',
                    style: TextStyle(fontFamily: "GennokiokuLCDFont")),
                content: Text('图片已成功保存至: $path',
                    style: TextStyle(fontFamily: "GennokiokuLCDFont")),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('确定'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("取消导出"),
          ));
        }
      } catch (e) {
        print('导出图片失败: $e');
      }
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
      body: ListView(
        children: [
          Row(
            children: [
              MenuBar(children: [
                MenuItemButton(
                  onPressed: _pickImage,
                  child: const Text(
                    "导入图片",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                MenuItemButton(
                  onPressed: _importStationName,
                  child: const Text(
                    "导入站名",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                ),
                MenuItemButton(
                  onPressed: _exportImage,
                  child: const Text(
                    "导出图片",
                    style: TextStyle(
                        fontFamily: "GennokiokuLCDFont", color: Colors.black),
                  ),
                )
              ]),
            ],
          ),
          Container(
            color: Colors.red,
            child: Stack(
              children: [
                _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.fitWidth)
                    : const Text(
                        '导入图片',
                        style: TextStyle(
                          fontFamily: "GennokiokuLCDFont",
                        ),
                      ),
                Container(
                  padding: EdgeInsets.fromLTRB(190, 165, 0, 0),
                  child: showStationName(stations),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack showStationName(List<Station> station) {
    //TODO 文字大小随窗口改变适应
    List<Container> tempList = [];
    double count = 0;
    for (var value in station) {
      tempList.add(Container(
        padding:
            EdgeInsets.fromLTRB((1400 / (station.length - 1)) * count, 0, 0, 0),
        child: Container(
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameCN,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "GennokiokuLCDFont",
              color: Colors.black,
            ),
          ),
        ),
      ));
      tempList.add(Container(
        padding:
        EdgeInsets.fromLTRB(15+(1400 / (station.length - 1)) * count, 10, 0, 0),
        child: Container(
          transform: Matrix4.rotationZ(-0.75),
          child: Text(
            value.stationNameEN,
            style: const TextStyle(
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

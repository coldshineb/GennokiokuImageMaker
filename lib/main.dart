import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:main/station.dart';
import 'package:path_provider/path_provider.dart';

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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _globalKey = GlobalKey();
  File? _imageFile;
  List<Text> _stationWidgets = [];
  List<Station> stations = [];

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

        final directory = await getApplicationDocumentsDirectory();
        final String path = '${directory.path}/screenshot.png';
        File imgFile = File(path);
        await imgFile.writeAsBytes(pngBytes);

        print('图片已保存至 $path');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('图片已导出'),
              content: Text('图片已成功保存至: $path'),
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
              style: TextStyle(fontFamily: "FZLTHPro Global")),
          foregroundColor: Colors.black,
          backgroundColor: Colors.blue,
          elevation: 5.0,
        ),
        body: Column(
          children: [
            Row(
              children: [
                MenuBar(children: [
                  MenuItemButton(
                    onPressed: _pickImage,
                    child: const Text(
                      "导入图片",
                      style: TextStyle(
                          fontFamily: "FZLTHPro Global", color: Colors.black),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: _importStationName,
                    child: const Text(
                      "导入站名",
                      style: TextStyle(
                          fontFamily: "FZLTHPro Global", color: Colors.black),
                    ),
                  ),
                  MenuItemButton(
                    onPressed: _exportImage,
                    child: const Text(
                      "导出图片",
                      style: TextStyle(
                          fontFamily: "FZLTHPro Global", color: Colors.black),
                    ),
                  )
                ]),
              ],
            ),
            RepaintBoundary(
              key: _globalKey,
              child: ImageContainer(
                imageFile: _imageFile,
              ),
            ),
          ],
        ));
  }
}

class StationNameContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [Text("123"), Text("456")],
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}

class ImageContainer extends StatelessWidget {
  final File? imageFile;

  //final List<Station>? stationWidgets;

  const ImageContainer({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      imageFile != null
          ? Image.file(imageFile!, fit: BoxFit.fitWidth)
          : const Text(
              '选择右上角 导入图片',
              style: TextStyle(
                fontFamily: "FZLTHPro Global",
              ),
            ),
    ]);
  }
}

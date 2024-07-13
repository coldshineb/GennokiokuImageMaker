import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:main/Object/EntranceCover.dart';

mixin class RoadSign {

  //显示下一站、当前站和终点站下拉菜单内容
  List<DropdownMenuItem> showEntranceList(List<EntranceCover> stationList) {
    List<DropdownMenuItem> tempList = [];
    try {
      for (EntranceCover value in stationList) {
        tempList.add(DropdownMenuItem(
          value: "${value.stationNameCN} ${value.entranceNumber}",
          child: Text("${value.stationNameCN} ${value.entranceNumber}"),
        ));
      }
    } on Exception catch (e) {
      print(e);
    }
    return tempList;
  }

  //菜单样式
  MenuStyle menuStyle(BuildContext context) {
    return MenuStyle(
      shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width, 48)),
    );
  }

  //原忆轨道交通图标
  Container gennokiokuRailwayTransitLogoWidget(bool show) {
    return show
        ? Container(
            padding: const EdgeInsets.fromLTRB(22.5, 5, 0, 0),
            alignment: Alignment.topLeft,
            height: 80,
            width: 274,
            child: SvgPicture.asset("assets/image/railwayTransitLogo.svg"))
        : Container();
  }

  //导入线路文件
  void importLineJson() async {}

  //导入纹理
  void importPattern() async {}

  //导出全部图
  void exportAllImage() async {}

  //导入导出菜单栏
  MenuBar importAndExportMenubar() {
    return const MenuBar(children: []);
  }

  //通用提示对话框方法
  void alertDialog(BuildContext context, String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("好"),
              )
            ],
          );
        });
  }

  //获取导出的图片数据
  Future<Uint8List> getExportImageBytes(GlobalKey<State<StatefulWidget>> key,
      {int? exportWidthValue, int? exportHeightValue}) async {
    //获取 key 对应的 stack 用于获取宽度
    RenderBox findRenderObject =
        key.currentContext!.findRenderObject() as RenderBox;

    //获取 key 对应的 stack 用于获取图片
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(
        pixelRatio: exportWidthValue != null
            ? exportWidthValue / findRenderObject.size.width
            : exportHeightValue! /
                findRenderObject.size.height); //根据传入的是宽度还是高度确定以哪个值计算 pixelRatio
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List(); //返回图片数据
  }

  //获取文件夹路径并（Android）导出
  Future<String?> getExportPath(
      BuildContext context, String dialogTitle, String fileName,
      [Uint8List? imageBytes]) async {
    String? path = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        type: FileType.image,
        bytes: imageBytes,
        //必须要在这里传 bytes，否则 android 上导出的文件大小为 0
        allowedExtensions: ["PNG"],
        lockParentWindow: true);
    if (path != null) {
      return path;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("取消导出"),
      ));
      return null;
    }
  }

  //通用图片导出方法
  Future<void> exportImage(BuildContext context,
      GlobalKey key, String fileName, bool isBatchExport,
      {int? exportWidthValue, int? exportHeightValue}) async {
    //导出尺寸按长还是宽确定，用命名参数指定
      String? path;
      Uint8List imageBytes = await getExportImageBytes(key,
          exportWidthValue: exportWidthValue,
          exportHeightValue: exportHeightValue); //获取图片数据
      try {
        if (isBatchExport) {
          //批量导出直接使用选择的路径+文件名写入
          path = fileName;
          File imgFile = File(fileName);
          await imgFile.writeAsBytes(imageBytes);
        } else {
          if (Platform.isAndroid) {
            path = await getExportPath(context, "保存", fileName, imageBytes);
            //Android 下返回路径并直接导出
          } else {
            //其他平台下 getExportPath 方法只返回路径，需要用 writeAsBytes 方法导出
            path = await getExportPath(context, "保存", fileName, imageBytes);
            File imgFile = File(path!);
            await imgFile.writeAsBytes(imageBytes);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("图片已成功保存至: $path"),
          ));
        }
      } catch (e) {
        print('导出图片失败: $e');
      }
  }

  //无线路信息 snackbar
  void noStationsSnackbar(context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("无线路信息"),
    ));
  }
}

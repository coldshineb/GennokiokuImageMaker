import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

//图片生成器大类接口
mixin class ImageMaker {
  //菜单样式
  MenuStyle menuStyle(BuildContext context) {
    return MenuStyle(
      shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      fixedSize:
          WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 48)),
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
        margin: EdgeInsets.all(10.0),
        behavior: SnackBarBehavior.floating,
        content: Text("取消导出"),
      ));
      return null;
    }
  }

  //通用图片导出方法
  Future<void> exportImage(BuildContext context, List listToCheckNonNull,
      GlobalKey key, String fileName, bool isBatchExport,
      {int? exportWidthValue, int? exportHeightValue}) async {
    //导出尺寸按长还是宽确定，用命名参数指定
    if (listToCheckNonNull.isNotEmpty) {
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
            margin: const EdgeInsets.all(10.0),
            behavior: SnackBarBehavior.floating,
            content: Text("图片已成功保存至: $path"),
          ));
        }
      } catch (e) {
        print('导出图片失败: $e');
      }
    } else {
      noStationsSnackbar(context);
    }
  }

  //导入导出菜单栏
  MenuBar importAndExportMenubar() {
    return const MenuBar(children: []);
  }

  //无线路信息 snackbar
  void noStationsSnackbar(context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      margin: EdgeInsets.all(10.0),
      behavior: SnackBarBehavior.floating,
      content: Text("无线路信息"),
    ));
  }

  Container importImageMenuItemButton(VoidCallback importImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: importImage,
          child: const Row(children: [
            Icon(Icons.image_outlined),
            SizedBox(width: 5),
            Text("导入图片")
          ])),
    );
  }

  Container importLineJsonMenuItemButton(VoidCallback importLineJson) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: importLineJson,
          child: const Row(
              children: [Icon(Icons.code), SizedBox(width: 5), Text("导入线路")])),
    );
  }

  Container importStationJsonMenuItemButton(VoidCallback importStationJson) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: importStationJson,
          child: const Row(
              children: [Icon(Icons.code), SizedBox(width: 5), Text("导入站名")])),
    );
  }

  Container exportAllImageMenuItemButton(VoidCallback exportAllImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportAllImage,
          child: const Row(children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 5),
            Text("导出全部图")
          ])),
    );
  }

  Container exportMainImageMenuItemButton(VoidCallback exportMainImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportMainImage,
          child: const Row(children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 5),
            Text("导出当前图")
          ])),
    );
  }

  Container exportThisStationImageMenuItemButton(
      VoidCallback exportThisStationImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportThisStationImage,
          child: const Row(children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 5),
            Text("导出当前站全部图")
          ])),
    );
  }

  Container exportRouteUpImageMenuItemButton(VoidCallback exportRouteUpImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportRouteUpImage,
          child: const Row(children: [
            Icon(Icons.arrow_circle_up),
            SizedBox(width: 5),
            Text("导出上行主线路图")
          ])),
    );
  }

  Container exportRouteDownImageMenuItemButton(
      VoidCallback exportRouteDownImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportRouteDownImage,
          child: const Row(children: [
            Icon(Icons.arrow_circle_down),
            SizedBox(width: 5),
            Text("导出下行主线路图")
          ])),
    );
  }

  Container exportStationImageMenuItemButton(VoidCallback exportStationImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportStationImage,
          child: const Row(
              children: [Icon(Icons.abc), SizedBox(width: 5), Text("导出站名图")])),
    );
  }

  Container exportDirectionUpImageMenuItemButton(
      VoidCallback exportDirectionUpImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportDirectionUpImage,
          child: const Row(children: [
            Icon(Icons.arrow_upward),
            SizedBox(width: 5),
            Text("导出上行运行方向图")
          ])),
    );
  }

  Container exportDirectionDownImageMenuItemButton(
      VoidCallback exportDirectionDownImage) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: exportDirectionDownImage,
          child: const Row(children: [
            Icon(Icons.arrow_downward),
            SizedBox(width: 5),
            Text("导出下行运行方向图")
          ])),
    );
  }

  Container exportMenuItemButton(method, text) {
    return Container(
      height: 48,
      child: MenuItemButton(
          onPressed: method,
          child: Row(children: [
            Icon(Icons.save_outlined),
            SizedBox(width: 5),
            Text(text)
          ])),
    );
  }
}

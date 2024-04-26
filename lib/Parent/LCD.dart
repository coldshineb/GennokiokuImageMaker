import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:main/Object/EntranceCover.dart';

import '../Object/Station.dart';
import '../Util/Widgets.dart';

mixin class LCD {
  //加载字体
  void loadFont() async {
    var fontLoader1 = FontLoader("GennokiokuLCDFont");
    fontLoader1
        .addFont(rootBundle.load('assets/font/FZLTHProGlobal-Regular.TTF'));
    var fontLoader2 = FontLoader("STZongyi");
    fontLoader2.addFont(rootBundle.load('assets/font/STZongyi.ttf'));
    await fontLoader1.load();
    await fontLoader2.load();
  }

  //显示下一站、当前站和终点站下拉菜单内容
  List<DropdownMenuItem> showStationList(List<Station> stationList) {
    List<DropdownMenuItem> tempList = [];
    try {
      for (Station value in stationList) {
        tempList.add(DropdownMenuItem(
          value: value.stationNameCN,
          child: Text(value.stationNameCN),
        ));
      }
    } on Exception catch (e) {
      print(e);
    }
    return tempList;
  }

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

  //线路标识
  Container lineNumberIconWidget(
      Color lineColor, String lineNumber, String lineNumberEN) {
    return Container(
      padding: const EdgeInsets.fromLTRB(270, 16, 0, 0),
      child: Widgets.lineNumberIcon(lineColor, lineNumber, lineNumberEN),
    );
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

  //通用导出方法
  Future<void> exportImage(
      GlobalKey key, String? path, bool showSnackbar) async {}

  //获取文件夹路径
  Future<String?> getExportPath(
      BuildContext context, String dialogTitle, String fileName) async {
    String? path = await FilePicker.platform.saveFile(
        dialogTitle: dialogTitle,
        fileName: fileName,
        type: FileType.image,
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
}

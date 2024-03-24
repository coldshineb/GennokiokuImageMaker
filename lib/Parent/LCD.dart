import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Object/Station.dart';
import '../Util.dart';
import '../Util/Widgets.dart';

mixin class LCD {
  //显示下一站、当前站和终点站下拉菜单内容
  List<DropdownMenuItem> showStationList(List<Station> stationList) {
    List<DropdownMenuItem> tempList = [];
    try {
      for (Station value in stationList) {
        value.stationNameCN;
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

  //原忆轨道交通图标
  Container gennokiokuRailwayTransitLogoWidget() {
    return Container(
        padding: const EdgeInsets.fromLTRB(22.5, 5, 0, 0),
        alignment: Alignment.topLeft,
        height: 274,
        width: 274,
        child: SvgPicture.string(Util.railwayTransitLogo));
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

  //导出全部图
  void exportAllImage() async {}

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

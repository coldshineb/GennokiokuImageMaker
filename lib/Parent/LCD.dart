import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../Object/Station.dart';

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

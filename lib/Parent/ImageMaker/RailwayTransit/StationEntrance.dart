import 'package:flutter/material.dart';

import '../../../Object/EntranceCover.dart';


mixin class StationEntrance {
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

  //导入线路文件
  void importStationJson() async {}

  //导入纹理
  void importPattern() async {}

  //导出全部图
  void exportAllImage() async {}

  //导入导出菜单栏
  MenuBar importAndExportMenubar() {
    return const MenuBar(children: []);
  }
}

import 'package:flutter/material.dart';

import '../../../Object/Station.dart';
import '../../../Util/Widgets.dart';

mixin class LCD {
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

  //导出分辨率选择下拉列表
  static List<DropdownMenuItem> resolutionList() {
    return [
      const DropdownMenuItem(
        value: 2560,
        child: Text("2560*500"),
      ),
      const DropdownMenuItem(
        value: 5120,
        child: Text("5120*1000"),
      ),
      const DropdownMenuItem(
        value: 10240,
        child: Text("10240*2000"),
      )
    ];
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

}

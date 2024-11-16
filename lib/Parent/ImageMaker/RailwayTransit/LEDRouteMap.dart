import 'package:flutter/material.dart';

import '../../../Object/Station.dart';
import '../../../Util.dart';
import '../../../Util/Widgets.dart';

mixin class LEDRouteMap {
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
        value: 3840,
        child: Text("3840*500"),
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

  //顶部标签
  Stack topLabels(
      String leftLabelCN,
      String leftLabelEN,
      String rightLabelCN,
      String rightLabelEN,
      int? leftStationListIndex,
      int? rightStationListIndex,
      List<Station> stationList) {
    return Stack(
      children: [
        Positioned(
            left: 0,
            top: 8,
            right: 723,
            child: Text(
              textAlign: TextAlign.center,
              leftLabelCN,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 0,
            top: 41,
            right: 723,
            child: Text(
              textAlign: TextAlign.center,
              leftLabelEN,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 592,
            top: 8,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              rightLabelCN,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 592,
            top: 41,
            right: 0,
            child: Text(
              textAlign: TextAlign.center,
              rightLabelEN,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 551,
            top: 8,
            child: Text(
              leftStationListIndex == null
                  ? ""
                  : stationList[leftStationListIndex].stationNameCN,
              //默认时索引为空，不显示站名；不为空时根据索引对应站名显示
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 1210.5,
            top: 8,
            child: Text(
              rightStationListIndex == null
                  ? ""
                  : stationList[rightStationListIndex].stationNameCN,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 551.5,
            top: 41,
            child: Text(
              leftStationListIndex == null
                  ? ""
                  : stationList[leftStationListIndex].stationNameEN,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            )),
        Positioned(
            left: 1210.5,
            top: 41,
            child: Text(
              rightStationListIndex == null
                  ? ""
                  : stationList[rightStationListIndex].stationNameEN,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: Util.railwayTransitLcdIsBoldFont,
                  color: Colors.black),
            ))
      ],
    );
  }

  //导入线路文件
  void importLineJson() async {}

  //导入纹理
  void importPattern() async {}

  //导出全部图
  void exportAllImage() async {}
}

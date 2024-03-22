import 'package:flutter/material.dart';

class Util {
  static const String railwayTransitLogo = '''
  <?xml version="1.0" encoding="UTF-8"?>
<svg id="_图层_2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 377.01 71.72">
    <g id="_图层_1-2">
        <text transform="translate(76.49 21.15)" fill="#040000" font-size="25.97">
            <tspan font-family="STZongyi">
                <tspan x="0" y="0">原忆轨道交通</tspan>
            </tspan>
            <tspan font-family="GennokiokuLCDFont">
                <tspan x="0" y="38.96">GENNOKIO</tspan>
                <tspan x="134.65" y="38.96" letter-spacing="0em">K</tspan>
                <tspan x="150.91" y="38.96">U RAI</tspan>
                <tspan x="215.81" y="38.96" letter-spacing="-.07em">L</tspan>
                <tspan x="228.18" y="38.96" letter-spacing="-.02em">W</tspan>
                <tspan x="250.44" y="38.96" letter-spacing="-.07em">A</tspan>
                <tspan x="266.31" y="38.96" letter-spacing="0em">Y</tspan>
            </tspan>
        </text>
        <path
            d="M66.74,10.43v45.89c0,5.67-4.53,10.28-10.17,10.42-.06-11.07-7.93-20.3-18.38-22.46v-4.42c6.3-.08,12.6-.16,18.9-.23-6.3-4.69-12.6-9.38-18.9-14.07v-4.96h8.42l-8.42-12V0h18.12c5.76,0,10.43,4.67,10.43,10.43ZM28.55,44.33v-4.47c-6.3-.08-12.6-.16-18.9-.23,6.3-4.69,12.6-9.38,18.9-14.07v-4.96h-8.47l8.47-12.07V0H10.43C4.67,0,0,4.67,0,10.43v45.89c0,5.76,4.67,10.43,10.43,10.43h0c.06-10.98,7.8-20.15,18.12-22.41ZM33.37,50.84c-9.55,0-17.31,7.1-17.46,15.9h34.92c-.15-8.81-7.91-15.9-17.46-15.9Z"
            fill="#55b9ea" stroke-width="0" />
    </g>
</svg>
  ''';

  static Color hexToColor(String hexColor) {
    // 移除可能包含的 '#' 符号
    hexColor = hexColor.replaceAll('#', '');

    // 如果16进制字符串长度不为6，则返回默认颜色
    if (hexColor.length != 6) {
      return Colors.black;
    }

    // 将16进制颜色转换为RGB值
    int red = int.parse(hexColor.substring(0, 2), radix: 16);
    int green = int.parse(hexColor.substring(2, 4), radix: 16);
    int blue = int.parse(hexColor.substring(4, 6), radix: 16);

    // 返回对应的Color对象
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  static Color getTextColorForBackground(Color backgroundColor) {
    // 计算颜色的亮度
    final double luminance =
        (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) /
            255;

    // 根据亮度值返回合适的文本颜色
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

}

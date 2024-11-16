import 'package:flutter/material.dart';
import '../Pages/ImageMaker/RailwayTransit/ScreenDoorCover.dart';

// 站点小图标
class LCDStationIconSmallPainter extends CustomPainter {
  final Color? lineColor; //线路主颜色
  final Color? lineVariantColor; //线路主颜色变体

  bool shadow;

  LCDStationIconSmallPainter(
      {required this.lineColor,
      required this.lineVariantColor,
      required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint mediumCircle = Paint()
      ..color = lineVariantColor!
      ..style = PaintingStyle.fill;

    final Paint innerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint shadowCircle = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    if (shadow) {
      //边缘阴影
      shadowCircle.maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);
      // 阴影圈圆
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), 16, shadowCircle);
    }
    // 外圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 17, outerCircle);
    // 中圈圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 12, mediumCircle);

    // 内圈圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 8.5, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 站点中图标
class LCDStationIconMediumPainter extends CustomPainter {
  final Color? lineColor; //线路主颜色
  final Color? lineVariantColor; //线路主颜色变体

  bool shadow;

  LCDStationIconMediumPainter(
      {required this.lineColor,
      required this.lineVariantColor,
      required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint mediumCircle = Paint()
      ..color = lineVariantColor!
      ..style = PaintingStyle.fill;

    final Paint innerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint shadowCircle = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    if (shadow) {
      //边缘阴影
      shadowCircle.maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);
      // 阴影圈圆
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), 40, shadowCircle);
    }
    // 外圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 41, outerCircle);

    // 中圈圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 27, mediumCircle);

    // 内圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 20, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 站点大图标
class LCDStationIconBigPainter extends CustomPainter {
  final Color? lineColor; //线路主颜色
  final Color? lineVariantColor; //线路主颜色变体

  bool shadow;

  LCDStationIconBigPainter(
      {required this.lineColor,
      required this.lineVariantColor,
      required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint mediumCircle = Paint()
      ..color = lineVariantColor!
      ..style = PaintingStyle.fill;

    final Paint innerCircle = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint shadowCircle = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    if (shadow) {
      //边缘阴影
      shadowCircle.maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);
      // 阴影圈圆
      canvas.drawCircle(
          Offset(size.width / 2, size.height / 2), 54, shadowCircle);
    }
    // 外圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 55, outerCircle);

    // 中圈圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 39, mediumCircle);

    // 内圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 26, innerCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 屏蔽门站点图标
class ScreenDoorCoverStationIconPainter extends CustomPainter {
  final Color? lineColor;

  ScreenDoorCoverStationIconPainter(this.lineColor); //线路主颜色

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final Paint rectPaint = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the outer circle
    canvas.drawCircle(center, 18, circlePaint);

    // Draw the rectangle
    final Rect rect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 36),
      width: 10,
      height: 40,
    );
    canvas.drawRect(rect, rectPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 屏蔽门盖板线路线条
class ScreenDoorCoverRouteLineClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    double radius = ScreenDoorCoverState.lineHeight;
    path.moveTo(0, size.height);
    path.arcToPoint(const Offset(0, 0),
        radius: Radius.circular(radius + 6), clockwise: false);
    path.lineTo(size.width, 0);
    path.arcToPoint(Offset(size.width, radius),
        radius: Radius.circular(radius + 6), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

// LED 线路图站点图标
class LEDRouteMapStationIconPainter extends CustomPainter {
  final Color fillColor;
  final Color strokeColor;
  final double radius;

  LEDRouteMapStationIconPainter(this.fillColor, this.strokeColor, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the filled circle
    canvas.drawCircle(center, radius, fillPaint);

    // Draw the circle border
    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

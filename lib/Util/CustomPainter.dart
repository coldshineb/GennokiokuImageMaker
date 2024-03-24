import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StationIconSmallPainter extends CustomPainter {
  final Color? lineColor; //线路主颜色
  final Color? lineVariantColor;

  bool shadow; //线路主颜色变体

  StationIconSmallPainter({required this.lineColor, required this.lineVariantColor,required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = lineColor!
      ..style = PaintingStyle.fill;

    final Paint lineVariantsPaint = Paint()
      ..color = lineVariantColor!
      ..style = PaintingStyle.fill;

    if (shadow) {
      //边缘阴影
      linePaint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 4);
    }
    // 外圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 17, linePaint);

    // 中圈圆
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), 12, lineVariantsPaint);

    // 内圈圆
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 8.5, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class LineIconPainter extends CustomPainter {
  final String number;
  final String chineseText;
  final String englishText;

  LineIconPainter(this.number, this.chineseText, this.englishText);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制圆角矩形
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    Rect rect = Offset.zero & size;
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(15.0)), paint);

    // 绘制数字
    TextPainter numberPainter = TextPainter(
      text: TextSpan(
        text: number,
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    numberPainter.layout();
    numberPainter.paint(
        canvas, Offset(10, size.height / 2 - numberPainter.height / 2));

    // 绘制中文字符
    TextPainter chinesePainter = TextPainter(
      text: TextSpan(
        text: chineseText,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    chinesePainter.layout();
    chinesePainter.paint(
        canvas,
        Offset(size.width / 2 - chinesePainter.width / 2,
            size.height / 4 - chinesePainter.height / 2));

    // 绘制英文字符
    TextPainter englishPainter = TextPainter(
      text: TextSpan(
        text: englishText,
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    );
    englishPainter.layout();
    englishPainter.paint(
        canvas,
        Offset(size.width / 2 - englishPainter.width / 2,
            size.height * 3 / 4 - englishPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

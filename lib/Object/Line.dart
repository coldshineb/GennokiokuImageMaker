class Line {
  final String lineNumber;
  final String lineNumberEN;
  final String lineColor;

  Line(
    this.lineNumber, {
    required this.lineNumberEN,
    required this.lineColor,
  });

  @override
  String toString() {
    return 'Line{lineNumber: $lineNumber, lineNumberEN: $lineNumberEN, lineColor: $lineColor}';
  }
}

class TransferLine {
  final String lineNumber;
  final String lineNumberEN;
  final String lineColor;

  TransferLine(
    this.lineNumber, {
    required this.lineNumberEN,
    required this.lineColor,
  });

  @override
  String toString() {
    return 'TransferLine{lineNumber: $lineNumber, lineColor: $lineColor}';
  }
}

class TransferLine {
  final String lineNumber;
  final String lineColor;

  TransferLine({
    required this.lineNumber,
    required this.lineColor,
  });

  @override
  String toString() {
    return 'TransferLine{lineNumber: $lineNumber, lineColor: $lineColor}';
  }
}

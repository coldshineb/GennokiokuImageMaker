import 'package:main/Object/Station.dart';

import 'Line.dart';

class EntranceCover extends Station {
  final String entranceNumbers;
  final List<Line> lines;

  EntranceCover({
    required super.stationNameCN,
    required super.stationNameEN,
    required this.entranceNumbers,
    required this.lines,
  });

  @override
  String toString() {
    return 'EntranceCover{stationNameCN: $stationNameCN, stationNameEN: $stationNameEN, entranceNumbers: $entranceNumbers, lines: $lines}';
  }
}

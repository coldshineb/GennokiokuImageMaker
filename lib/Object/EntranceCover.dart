
import 'Line.dart';
import 'Station.dart';

class EntranceCover extends Station {
  final String entranceNumber;
  final List<Line> lines;

  EntranceCover({
    required super.stationNameCN,
    required super.stationNameEN,
    required this.entranceNumber,
    required this.lines,
  });

  @override
  String toString() {
    return 'EntranceCover{stationNameCN: $stationNameCN, stationNameEN: $stationNameEN, entranceNumber: $entranceNumber, lines: $lines}';
  }
}

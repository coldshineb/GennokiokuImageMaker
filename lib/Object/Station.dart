import 'TransferLine.dart';

class Station {
  final String stationNameCN;
  final String stationNameEN;

  Station({
    required this.stationNameCN,
    required this.stationNameEN,
  });

  @override
  String toString() {
    return 'Station{stationNameCN: $stationNameCN, stationNameEN: $stationNameEN}';
  }
}

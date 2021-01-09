import 'package:google_maps_flutter/google_maps_flutter.dart';

class Carpark {
  final String carparkId;
  final String area;
  final String development;
  final LatLng location;
  final int availableLots;
  final String lotType;
  final String agency;

  Carpark(
      {this.carparkId,
      this.area,
      this.development,
      this.location,
      this.availableLots,
      this.lotType,
      this.agency});

  Carpark.fromCarpark(Carpark carpark)
      : carparkId = carpark.carparkId,
        area = carpark.area,
        development = carpark.development,
        location = carpark.location,
        availableLots = carpark.availableLots,
        lotType = carpark.lotType,
        agency = carpark.agency;

  factory Carpark.fromJson(Map<String, dynamic> json) {
    List<String> coords = json['Location'].split(" ");
    LatLng location =
        new LatLng(double.parse(coords[0]), double.parse(coords[1]));

    return Carpark(
      carparkId: json['CarParkID'],
      area: json['Area'],
      development: json['Development'],
      location: location,
      availableLots: json['AvailableLots'],
      lotType: json['LotType'],
      agency: json['Agency'],
    );
  }

  Carpark withPrice() {
    return this;
  }

  bool operator ==(o) => o is Carpark && carparkId == o.carparkId;
  int get hashCode => carparkId.hashCode;
}

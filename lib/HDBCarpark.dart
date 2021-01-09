import 'package:hacknroll2021/Carpark.dart';

class HDBCarpark extends Carpark {
  String carparktype;
  String system;
  String shortTermParking;
  String freeParking;
  String nightParking;

  HDBCarpark.fromCarpark(
      {Carpark carpark,
      this.carparktype,
      this.system,
      this.shortTermParking,
      this.freeParking,
      this.nightParking})
      : super.fromCarpark(carpark);

  factory HDBCarpark.fromJson(Carpark carpark, Map<String, String> json) {
    return HDBCarpark.fromCarpark(
      carpark: carpark,
      carparktype: json['car_park_type'],
      system: json['type_of_parking_system'],
      shortTermParking: json['short_term_parking'],
      freeParking: json['free_parking'],
      nightParking: json['night_parking'],
    );
  }

  @override
  HDBCarpark withPrice() {
    return this;
  }
}

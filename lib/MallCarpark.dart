import 'package:hacknroll2021/Carpark.dart';

class MallCarpark extends Carpark {
  String weekday1;
  String weekday2;
  String sat;
  String sunPH;

  MallCarpark.fromCarpark(
      {Carpark carpark, this.weekday1, this.weekday2, this.sat, this.sunPH})
      : super.fromCarpark(carpark);

  factory MallCarpark.fromJson(Carpark carpark, Map<String, String> json) {
    return MallCarpark.fromCarpark(
      carpark: carpark,
      weekday1: json['WeekDays_Rate_1'],
      weekday2: json['WeekDays_Rate_2'],
      sat: json['Saturday_Rate'],
      sunPH: json['Sunday_PublicHoliday_Rate'],
    );
  }

  @override
  MallCarpark withPrice() {
    return this;
  }
}

import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hacknroll2021/Carpark.dart';
import 'package:hacknroll2021/HDBCarpark.dart';
import 'package:hacknroll2021/MallCarpark.dart';
import 'package:http/http.dart' as http;

class DataSource {
  final String sourceURL =
      'http://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2';

  final Map<String, String> headers = {
    'AccountKey': FlutterConfig.get('ACCOUNT_KEY')
  };

  final String hdbInfoSource = "assets/hdb-carpark-information.csv";
  final String mallInfoSource = "assets/CarParkRates.csv";

  Map<String, Map<String, String>> hdbInfo = Map();
  Map<String, Map<String, String>> mallInfo = Map();

  Future<http.Response> fetchDataRaw() {
    return http.get(sourceURL, headers: headers);
  }

  Future<List<Carpark>> fetchData() async {
    int skip = 0;
    bool stop = false;
    List<Carpark> carparkList = [];

    //HDB Price Data
    List<List<dynamic>> hdbData = await rootBundle.loadStructuredData(
        hdbInfoSource,
        (csv) => Future.value(CsvToListConverter().convert(csv)));

    hdbData.forEach((entry) {
      Map<String, String> data = Map();
      data['car_park_no'] = entry[0].toString();
      data['address'] = entry[1].toString();
      data['x_coord'] = entry[2].toString();
      data['y_coord'] = entry[3].toString();
      data['car_park_type'] = entry[4].toString();
      data['type_of_parking_system'] = entry[5].toString();
      data['short_term_parking'] = entry[6].toString();
      data['free_parking'] = entry[7].toString();
      data['night_parking'] = entry[8].toString();
      data['car_park_decks'] = entry[9].toString();
      data['gantry_height'] = entry[10].toString();
      data['car_park_basement'] = entry[11].toString();

      hdbInfo[entry.first.toString()] = data;
    });

    //Mall Price Data
    List<List<dynamic>> mallData = await rootBundle.loadStructuredData(
        mallInfoSource,
        (csv) => Future.value(CsvToListConverter().convert(csv)));
    mallData.forEach((entry) {
      Map<String, String> data = Map();
      data['CarPark'] = entry[0].toString();
      data['Category'] = entry[1].toString();
      data['WeekDays_Rate_1'] = entry[2].toString();
      data['WeekDays_Rate_2'] = entry[3].toString();
      data['Saturday_Rate'] = entry[4].toString();
      data['Sunday_PublicHoliday_Rate'] = entry[5].toString();

      mallInfo[entry.first.toString()] = data;
    });

    //Availability data
    do {
      String finalURL = sourceURL + "?\$skip=$skip";
      http.Response response = await http.get(finalURL, headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> rawList = data['value'];
        rawList.forEach((element) {
          Carpark carpark = Carpark.fromJson(element);
          if (hdbInfo.containsKey(carpark.carparkId)) {
            Map<String, String> priceInfo = hdbInfo[carpark.carparkId];
            carpark = HDBCarpark.fromJson(carpark, priceInfo);
          }

          if (mallInfo.containsKey(carpark.development)) {
            Map<String, String> priceInfo = mallInfo[carpark.development];
            carpark = MallCarpark.fromJson(carpark, priceInfo);
          }

          carparkList.add(carpark);
        });

        if (rawList.length < 500) {
          stop = true;
        }
      } else {
        throw Exception("Failed to load data");
      }
      skip += 500;
    } while (!stop);

    return carparkList.toSet().toList(); //remove duplicates
  }
}

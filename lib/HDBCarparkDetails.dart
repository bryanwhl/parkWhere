import 'package:flutter/material.dart';
import 'package:hacknroll2021/AvailableLots.dart';
import 'package:hacknroll2021/GoogleMapsButton.dart';
import 'package:hacknroll2021/HDBCarpark.dart';

import 'ModelLoader.dart';

class HDBCarParkDetails extends StatelessWidget {
  final ScrollController _sc;
  final HDBCarpark carpark;
  final ModelLoader _modelLoader;

  HDBCarParkDetails(this._sc, this.carpark, this._modelLoader);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListView(
        controller: _sc,
        children: <Widget>[
          SizedBox(
            height: 18.0,
          ),
          Container(
            height: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                child: Text(
                  carpark.development ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 85,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Text(
                              carpark.system,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12.0),
                            ),
                            Text(
                              carpark.carparktype,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12.0),
                            ),
                            Text(
                              "NIGHT PARKING: ${carpark.nightParking}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12.0),
                            ),
                            Text(
                              "SHORT-TERM: ${carpark.shortTermParking}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12.0),
                            ),
                            Text(
                              "FREE PARKING: ${carpark.freeParking}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AvailableLots(
                      carpark: carpark,
                      modelLoader: _modelLoader,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GoogleMapsButton(null, carpark.location),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hacknroll2021/AvailableLots.dart';
import 'package:hacknroll2021/GoogleMapsButton.dart';
import 'package:hacknroll2021/MallCarpark.dart';

import './ModelLoader.dart';

class MallCarParkDetails extends StatelessWidget {
  final ScrollController _sc;
  final MallCarpark carpark;
  final ModelLoader _modelLoader;

  MallCarParkDetails(this._sc, this.carpark, this._modelLoader);

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
                            "WEEKDAY:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            carpark.weekday1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            carpark.weekday2,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            "SATURDAY:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            carpark.sat,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            "SUNDAY & PH:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                          Text(
                            carpark.sunPH,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12.0),
                          ),
                        ],
                      ),
                    )),
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
//          FlatButton(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(8.0),
//                side: BorderSide(color: Colors.blueAccent)),
//            color: Colors.blueAccent,
//            textColor: Colors.white,
//            padding: EdgeInsets.symmetric(vertical: 8.0),
//            onPressed: () {},
//            child: Text(
//              "Bring me there",
//              style: TextStyle(
//                fontSize: 28.0,
//              ),
//            ),
//          ),
          GoogleMapsButton(null, carpark.location),
        ],
      ),
    );
  }
}

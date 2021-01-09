import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapsButton extends StatelessWidget {
  final LatLng origin;
  final LatLng destination;

  GoogleMapsButton(this.origin, this.destination);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.blueAccent)),
      color: Colors.blueAccent,
      textColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      onPressed: () {
        openMap(origin, destination);
      },
      child: Text(
        "Bring me there",
        style: TextStyle(
          fontSize: 28.0,
        ),
      ),
    );
  }

  Future<void> openMap(LatLng origin, LatLng destination) async {
    String originCoord =
        origin == null ? '' : '${origin.latitude},${origin.longitude}';
    String destinationCoord =
        '${destination.latitude},${destination.longitude}';

    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$originCoord&destination=$destinationCoord';
    String appleUrl =
        'http://maps.apple.com/?saddr=$originCoord&daddr=$destinationCoord';

    if (Platform.isIOS && await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else if (Platform.isAndroid && await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

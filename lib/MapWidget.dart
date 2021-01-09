import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:google_maps_webservice/places.dart";
import 'package:hacknroll2021/Carpark.dart';
import 'package:hacknroll2021/LocationService.dart';

import './Place.dart';

class MapWidget extends StatefulWidget {
  final Function(Carpark) selectCallback;
  final Function loadedCallback;
  MapWidget({this.selectCallback, this.loadedCallback, Key key})
      : super(key: key);

  @override
  MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Future<List<Carpark>> _carparkList;
  GoogleMapController _mapController;

  String _mapStyle;
  BitmapDescriptor _availableIcon;
  BitmapDescriptor _notAvailableIcon;
  LocationService _locationHandler;

  Set<Marker> markers;
  Marker locationMarker;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _locationHandler = new LocationService();
    _carparkList = _locationHandler.returnNearestCarparkListFromCurrent();

    getBytesFromAsset("assets/images/GreenMarker.png", 80).then((bitmap) {
      _availableIcon = BitmapDescriptor.fromBytes(bitmap);
    });

    getBytesFromAsset("assets/images/RedMarker.png", 80).then((bitmap) {
      _notAvailableIcon = BitmapDescriptor.fromBytes(bitmap);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void moveToSearchLocation(Place place) async {
    final places =
        new GoogleMapsPlaces(apiKey: FlutterConfig.get('MAPS_API_KEY'));
    PlacesDetailsResponse response =
        await places.getDetailsByPlaceId(place.placeId);
    Location loc = response.result.geometry.location;
    CameraPosition(target: LatLng(loc.lat, loc.lng));
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(loc.lat, loc.lng), zoom: 17.0));
    _mapController.moveCamera(cameraUpdate);
    setState(() {
      _carparkList =
          _locationHandler.returnNearestCarparkList(loc.lat, loc.lng);
      locationMarker = Marker(
          markerId: MarkerId("currentLocation"),
          position: LatLng(loc.lat, loc.lng));
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
    await Future.delayed(Duration(seconds: 1));
    widget.loadedCallback();
  }

  Set<Marker> generateMarkers(List<Carpark> carparkList) {
    Set<Marker> markerList = carparkList.map(
      (carpark) {
        return Marker(
          markerId: MarkerId(carpark.carparkId),
          position: carpark.location,
          icon: carpark.availableLots > 10 ? _availableIcon : _notAvailableIcon,
          onTap: () {
            widget.selectCallback(carpark);
          },
        );
      },
    ).toSet();

    if (locationMarker != null) {
      markerList.add(locationMarker);
    }

    return markerList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Carpark>>(
      future: _carparkList,
      builder: (BuildContext context, AsyncSnapshot<List<Carpark>> snapshot) {
        if (snapshot.hasData) {
          List<Carpark> data = snapshot.data;
          Set<Marker> markers = generateMarkers(data);

          LatLng currentPosition = LatLng(
              _locationHandler.currentPosition.latitude,
              _locationHandler.currentPosition.longitude);
          return GoogleMap(
            onMapCreated: _onMapCreated,
            tiltGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: currentPosition,
              zoom: 17.0,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          );
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return Container();
        }
      },
    );
  }
}

import 'package:geolocator/geolocator.dart';
import 'package:hacknroll2021/Carpark.dart';
import 'package:hacknroll2021/DataSource.dart';
import 'package:latlong/latlong.dart';

class LocationService {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.

  Position currentPosition;
  final Position _defaultPosition =
      new Position(longitude: 1.2966, latitude: 103.7764);

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return Geolocator.getCurrentPosition().then((position) {
      currentPosition = position;
      return position;
    });
  }

  Future<List<Carpark>> returnNearestCarparkListFromCurrent() async {
    Position position = await _determinePosition();
    return returnNearestCarparkList(position.latitude, position.longitude);
  }

  Future<List<Carpark>> returnNearestCarparkList(
      double latitude, double longitude) async {
    double distanceQuota = 500.0;
    DataSource dataSource = new DataSource();
    List<Carpark> carparkList = await dataSource.fetchData();
    List<Carpark> nearestCarparkList = new List<Carpark>();
    var position = new LatLng(latitude, longitude);
    var distance = new Distance();
    for (int i = 0; i < carparkList.length; i++) {
      Carpark carpark = carparkList.elementAt(i);
      var carparkPosition =
          new LatLng(carpark.location.latitude, carpark.location.longitude);
      if (distance.as(LengthUnit.Meter, position, carparkPosition) <
          distanceQuota) {
        nearestCarparkList.add(carpark);
      }
    }
    return nearestCarparkList;
  }

  Position returnCurrentPosition() {
    return currentPosition ?? _defaultPosition;
  }
}

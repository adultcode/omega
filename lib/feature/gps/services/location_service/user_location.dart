import 'package:geolocator/geolocator.dart';

class UserLocation{
  /*
    calculate difference of two points
     */
  double calculateDistance(Position pre,Position current) {
    double distanceInMeters = Geolocator.distanceBetween(
      pre.latitude,
      pre.longitude,
      current.latitude,
      current.longitude,
    );
    return distanceInMeters;
  }
}
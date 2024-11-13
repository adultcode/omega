import 'package:geolocator/geolocator.dart';
import 'package:gpsapp/feature/gps/model/location_model.dart';

class UserLocation{
  /*
    calculate difference of two points
     */
 static double calculateDistance(LocationModel pre,LocationModel current) {
    double distanceInMeters = Geolocator.distanceBetween(
      pre.lat!,
      pre.long!,
      current.lat!,
      current.long!,
    );
    return distanceInMeters;
  }
}
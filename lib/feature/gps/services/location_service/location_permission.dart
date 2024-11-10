import 'package:geolocator/geolocator.dart';


Future<bool> CheckUserPermission()async{
  print("Checking");
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied){
    print("Denied");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Denied2");
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("deniedForever");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

  }
  return true;
}

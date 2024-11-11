import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../services/files.dart';
import '../services/local_req.dart';
import '../services/location_service/location_permission.dart';

class GPSState extends ChangeNotifier{


  String location = "";
  Position? _current_position;

  void AddLocation(String newLocation) async{
    // check for permission

    if( await CheckUserPermission() == true){
      // get current location
    // _current_position =   await Geolocator.getCurrentPosition();
    // print("Location: ${_current_position.toString()}");
    // check distance
   // check time difference
    // add location to db
    print("-- ADD location");
    // location+="\n ${_current_position!.latitude},${_current_position!.latitude}";
    // DateTime now = DateTime.now();

 //   SendReq("${now.minute}-${now.second}:${_current_position!.latitude},${_current_position!.latitude}");
    FileHelper.createAndAppendText(newLocation);
    notifyListeners();
    }
  }




}
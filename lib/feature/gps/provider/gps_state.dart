import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpsapp/feature/gps/model/location_model.dart';
import 'package:latlong2/latlong.dart';

import '../services/db_service/location_db.dart';
import '../services/location_service/location_permission.dart';

class GPSState extends ChangeNotifier{


  late LocationDB _locationDB;

  List<LocationModel>? _location_list = [];
  List<Marker>? markers = [];

  // getch loations from db and create markers
  void MapMarkers()async{

    _locationDB = LocationDB();
    _location_list = await _locationDB.GetAllLocation();
    if(_location_list!=null && _location_list!.isNotEmpty){

      _location_list!.forEach((element) {

        markers!.add(  Marker(
            point: LatLng(element.lat!, element!.long!),
            width: 64,
            height: 64,
            alignment: Alignment.centerLeft,
            child: Container(
              child: Icon(Icons.location_on,color: Colors.blue,size: 40,),
            )
        ));
      },);
    }
    notifyListeners();

  }

  void DeleteRecords()async{
    _locationDB = LocationDB();
    await _locationDB.DeleteDB();
    markers!.clear();
    notifyListeners();
  }




}
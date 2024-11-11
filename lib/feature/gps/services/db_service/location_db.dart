import 'package:realm/realm.dart';

import '../../model/location_model.dart';

class LocationDB{

  static final LocationDB _instance = LocationDB._internal();


 late  Realm _realm;
  factory LocationDB() {
    return _instance;
  }

  LocationDB._internal() {
    var config = Configuration.local([LocationModel.schema]);
     _realm = Realm(config);
  }


  // Add Record
Future<bool> AddLocation(LocationModel location)async{

    try{
      _realm.write(() {
        _realm.add(location);
      });
      return true;

    }catch(e){
      print("--- Error in db: ${e.toString()}");
      return false;
    }

}
  // Add Record
  Future<bool> DeleteDB()async{

    try{
      _realm.write(() {
        _realm.deleteAll<LocationModel>();
      },);
      return true;

    }catch(e){
      print("--- Error in db: ${e.toString()}");
      return false;
    }

  }
// get all records
Future<List<LocationModel>?> GetAllLocation()async{

    try{
      print("All data");
      return  _realm.all<LocationModel>().map((e) {
        print("Time: ${e.timestamp} - Long:${e.long}");
        return LocationModel(e.timestamp,lat: e.lat,long: e.long);
      }).toList();
    }catch(e){
      return Future.error(e.toString());
    }
}


}
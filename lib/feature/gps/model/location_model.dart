import 'package:realm/realm.dart';
part 'location_model.realm.dart'; // declare a part file.

@RealmModel()
class _LocationModel{

  @PrimaryKey()
  int? timestamp;
  double? long;
  double? lat;

  // LocationModel({required this.timestamp,required this.long,required this.lat});
}
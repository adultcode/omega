import 'dart:async';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gpsapp/feature/gps/model/location_model.dart';
import 'package:gpsapp/feature/gps/provider/gps_state.dart';
import 'package:provider/provider.dart';

import '../../../../dependency/get_it.dart';
import '../db_service/location_db.dart';
import '../files.dart';
import '../location_service/user_location.dart';

class ForegroundTaskService{
  static ReceivePort? _receivePort;

  static init(){
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'main_channel',
        channelName: 'Main',
        channelDescription: 'Notification foreground',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,

      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(2000)

      ),
    );


  }

  static ReceivePort? get receivePort => _receivePort;
  }



@pragma('vm:entry-point') // This decorator means that this function calls native code
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  late LocationDB _locationDB;
  LocationModel? last_location;
  LocationModel? current_location;

  LocationSettings locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.high,
  //  distanceFilter: 10, // Fetches every 10 meters change
    //timeLimit: Duration(seconds: 1)
    forceLocationManager: true,
    intervalDuration: const Duration(seconds: 1),
  );

  FirstTaskHandler(){
    _locationDB = LocationDB();
  }
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // TODO: implement onDestroy
    print('onDestroy');
    //_timer?.cancel();
    FlutterForegroundTask.stopService();

  }

  @override
  void onRepeatEvent(DateTime timestamp)async {

    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
    FlutterForegroundTask.sendDataToMain(data);
   //  FlutterForegroundTask.sendDataToMain("gps");

    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    DateTime now = DateTime.now();

    current_location = LocationModel(now.millisecondsSinceEpoch,lat: position.latitude,long: position.longitude);
    if(last_location == null ){
      // there is no previous record
      print("Added-there is no previous record ");
      await _locationDB.AddLocation(current_location!);
      last_location  = current_location;

    }
    // checking distance or time
    else if(UserLocation.calculateDistance(last_location!, current_location!)>50.0 ||
        (now.millisecondsSinceEpoch - last_location!.timestamp!).abs()~/ (1000 )>=60){

      // print("Distance: ${UserLocation.calculateDistance(last_location!, current_location!)}");
      // print("Added location after 5sec- ${now.difference(DateTime.fromMillisecondsSinceEpoch(last_location!.timestamp!)).inDays}");
      await _locationDB.AddLocation(current_location!);
      last_location  = current_location;

    }

    // FlutterForegroundTask.sendDataToMain({
    //   'latitude': position.latitude,
    //   'longitude': position.longitude,
    //   'timestamp': timestamp.millisecondsSinceEpoch,
    // });
    // print({
    //   'latitude': position.latitude,
    //   'longitude': position.longitude,
    //   'timestamp': timestamp.millisecondsSinceEpoch,
    // });

   // FileHelper.createAndAppendText("${now.minute}-${now.second}:${position!.latitude},${position!.latitude}");

   // await _locationDB.AddLocation(LocationModel(now.microsecondsSinceEpoch,lat: position.latitude,long: position.longitude));
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // TODO: implement onStart
    print('onStart(starter: ${starter.name})');
     // get latest location from DB
    last_location = await _locationDB.GetLatestLocation();

    print("-------- LAST locatioN: ${last_location!.timestamp!}");
     // This is used for communicating between our service and our app
    FlutterForegroundTask.sendDataToMain("startTask");
    _sendPort?.send("startTask22");

  }

  @override
  void onReceiveData(Object data) {
    print('onReceiveData: $data');
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed: $id');
   // _sendPort?.send("killTask");

  }


}

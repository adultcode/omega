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
     FlutterForegroundTask.sendDataToMain("gps");

    Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);
    FlutterForegroundTask.sendDataToMain({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
    print({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    });
    DateTime now = DateTime.now();

   // FileHelper.createAndAppendText("${now.minute}-${now.second}:${position!.latitude},${position!.latitude}");

    await _locationDB.AddLocation(LocationModel(now.microsecondsSinceEpoch,lat: position.latitude,long: position.longitude));
    // Depend.app_context?.read<GPSState>().AddLocation("T: ${timestamp.minute}:${timestamp.second}");
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    // TODO: implement onStart
    print('onStart(starter: ${starter.name})');

     // This is used for communicating between our service and our app
    FlutterForegroundTask.sendDataToMain("startTask");
    _sendPort?.send("startTask22");
    // sendPort?.send("startTask");

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

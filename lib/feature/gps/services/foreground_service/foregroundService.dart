import 'dart:async';
import 'dart:isolate';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:gpsapp/feature/gps/provider/gps_state.dart';
import 'package:provider/provider.dart';

import '../../../../dependency/get_it.dart';

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
        // iconData: const NotificationIconData(
        //   resType: ResourceType.mipmap,
        //   resPrefix: ResourcePrefix.ic,
        //   name: 'launcher',
        // ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
          eventAction: ForegroundTaskEventAction.repeat(1000)

      ),
    );

    // Initialize communication port only once
    // if (_receivePort == null) {
    //   FlutterForegroundTask.initCommunicationPort();
    //   _receivePort = FlutterForegroundTask.receivePort;
    // }
  }

  static ReceivePort? get receivePort => _receivePort;
  }



@pragma('vm:entry-point') // This decorator means that this function calls native code
void startCallback() {
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // TODO: implement onDestroy
    print('onDestroy');
    //_timer?.cancel();
    FlutterForegroundTask.stopService();

  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // Send data to the main isolate.
    //Provider.of<GPSState>(Depend.app_context!,listen: false).AddLocation("T: ${timestamp.minute}:${timestamp.second}");

    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
 //   print("repeat");
 //   FlutterForegroundTask.sendDataToMain(data);
     FlutterForegroundTask.sendDataToMain("gps");

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
    _sendPort?.send("killTask");

  }


}

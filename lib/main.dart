import 'dart:io';
import 'dart:isolate';
import 'package:latlong2/latlong.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:gpsapp/feature/gps/model/location_model.dart';
import 'package:gpsapp/feature/gps/provider/gps_state.dart';
import 'package:gpsapp/feature/gps/services/foreground_service/foregroundService.dart';
import 'package:provider/provider.dart';

import 'dependency/get_it.dart';
import 'feature/gps/services/db_service/location_db.dart';
import 'feature/gps/services/location_service/location_permission.dart';


late AwesomeNotifications notifications;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();





  // foreground class init
  ForegroundTaskService.init();

  runApp(MultiProvider(providers: [
  ChangeNotifierProvider(create: (context) => GPSState(),)
  ],
  child: MyApp(),));


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Depend.app_context = context;
    return MaterialApp(
      title: 'Flutter Demo',
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ReceivePort? receivePort;

  @override
  initState(){
    super.initState();

     FlutterForegroundTask.initCommunicationPort();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Request permissions and initialize the service.
      await _requestPermissions();
    });
     //


   // FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);
    receivePort = FlutterForegroundTask.receivePort;

  }

  // void _onReceiveTaskData(Object data) {
  //
  //
  //
  //
  //   if (data is Map<String, dynamic>) {
  //     final dynamic timestampMillis = data["timestampMillis"];
  //     if (timestampMillis != null) {
  //       final DateTime timestamp =
  //       DateTime.fromMillisecondsSinceEpoch(timestampMillis, isUtc: true);
  //      // print('timestamp: ${timestamp.toString()}');
  //     }
  //   }
  //   else{
  //     // print("Data: $data");
  //   }
  // }

  void startService()async{
    // check permission
    var status = await CheckUserPermission();
    print("- Permission status: $status");
    if( status == true){
      //start service or restart
      if (await FlutterForegroundTask.isRunningService) {
        FlutterForegroundTask.restartService();
      }
      else {
        FlutterForegroundTask.startService(
          notificationTitle: 'Foreground Service is running',
          notificationText: 'Tap to return to the app',
          serviceId:10,
          callback: startCallback, // Function imported from ForegroundService.dart
        );

      }
    }

    }

  Future<void> _requestPermissions() async {


    AwesomeNotifications().isNotificationAllowed().then((isAllowed)async {
      if (!isAllowed) {
        await FlutterForegroundTask.requestNotificationPermission();

      }
    });
    if (Platform.isAndroid) {
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

    }
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().colorScheme.primaryContainer,
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /*
                start service
                 */
                ElevatedButton(onPressed: () async{

                  startService();

                }, child: Text("شروع ")),
                /*
                stop service
                 */
                ElevatedButton(onPressed: () async{
                  FlutterForegroundTask.stopService();

                  // await _locationDB.GetAllLocation();

                }, child: Text("پایان ")),
                /*
                delete all records
                 */
                ElevatedButton(onPressed: () async{
                  FlutterForegroundTask.stopService();

                  Provider.of<GPSState>(context,listen: false).MapMarkers();

                }, child: Text("نمایش ")),
                ElevatedButton(onPressed: () async{

                  Provider.of<GPSState>(context,listen: false).DeleteRecords();

                }, child: Text("ریست ")),
              ],
            ),

            Expanded(
              child:
              Consumer<GPSState>(builder: (context, value, child) {
                print("Markers: ${value.markers.toString()}");
                 return   FlutterMap(
                  options: MapOptions(

                    initialCenter: LatLng(35.6910624,51.3852453), // Initial map center
                    initialZoom: 10.0, // Initial zoom level
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],

                    ),
                    MarkerLayer(markers: value.markers!)
                  ],

                );
              },)

              )
          ]
            ),
            ),


    );
  }
}

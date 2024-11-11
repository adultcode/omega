
import 'package:dio/dio.dart';
var url = "https://flutter-learn.ir/file/test.php?data=";
void SendReq(String title)async{
  final dio = Dio();

  var response = await dio.get(url+title);
  print("Response: ${response.data}");
}
import 'dart:async';

class SomeTask{
  Timer? _timer;
  void performTask(){

    // Do some task
    Timer.periodic( Duration(seconds:2),(timer){
      print("Executing in foreground every2sec!");
    });
  }


  void killTask(){
    _timer?.cancel();
  }
}
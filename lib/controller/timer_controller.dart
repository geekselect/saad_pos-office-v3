import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerController extends GetxController {
  RxBool isTimerRunning = false.obs;
  Rx<Duration> timerDuration = Duration.zero.obs;
  Timer? _timer;

  DateTime? startTime;
  DateTime? stopTime;
  Duration? elapsedTime;

  void startTimer() {
    isTimerRunning.value = true;
    startTime = DateTime.now().subtract(timerDuration.value);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      timerDuration.value = timerDuration.value + const Duration(seconds: 1);
    });
  }

  void stopTimer() {
    isTimerRunning.value = false;
    timerDuration.value = Duration.zero;
    _timer?.cancel();
     stopTime = DateTime.now();
    _timer = null;
    calculateElapsedTime();
  }

  Future<void> calculateElapsedTime() async {
    if (startTime != null && stopTime != null) {
      elapsedTime = stopTime!.difference(startTime!);
      await saveTimes();
    }
  }

  Future<void> saveTimes() async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setString('start_time', startTime.toString());
      await prefs.setString('stop_time', stopTime.toString());
      await prefs.setInt('elapsed_time', elapsedTime!.inSeconds);
    }

  Future<void> fetchTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeString = prefs.getString('start_time');
    final stopTimeString = prefs.getString('stop_time');
    final elapsedTimeSeconds = prefs.getInt('elapsed_time');

    if (startTimeString != null && stopTimeString != null && elapsedTimeSeconds != null) {
      startTime = DateTime.parse(startTimeString);
      stopTime = DateTime.parse(stopTimeString);
      elapsedTime = Duration(seconds: elapsedTimeSeconds);
    }

  }

  @override
  void onInit() {
    super.onInit();
    fetchTimes();
  }


  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}


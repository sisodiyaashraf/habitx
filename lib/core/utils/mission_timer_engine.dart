import 'dart:async';

class MissionTimerEngine {
  Timer? _timer;
  int _currentSeconds = 0;
  final Function(int) onTick;
  final Function() onComplete;

  MissionTimerEngine({required this.onTick, required this.onComplete});

  int get currentSeconds => _currentSeconds;
  bool get isActive => _timer != null && _timer!.isActive;

  /// Initializes the timer with a specific duration (in minutes)
  void start(int minutes) {
    stop(); // Ensure any previous timer is killed
    _currentSeconds = minutes * 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        onTick(_currentSeconds);
      } else {
        stop();
        onComplete();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void pause() => _timer?.cancel();
}

import 'package:flutter_tts/flutter_tts.dart';

class AccessibilityService {
  final FlutterTts _tts = FlutterTts();
  bool _isEnabled = true;

  AccessibilityService() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  bool get isEnabled => _isEnabled;

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> speak(String text) async {
    if (_isEnabled) {
      await _tts.speak(text);
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> announceNavigation(String screenName) async {
    await speak('Navigated to $screenName screen');
  }

  Future<void> announceAction(String action) async {
    await speak(action);
  }

  Future<void> announceStationSelected(String stationName) async {
    await speak('Selected $stationName');
  }

  Future<void> announcePlaybackState(String state, String? stationName) async {
    if (stationName != null) {
      await speak('$state $stationName');
    } else {
      await speak(state);
    }
  }

  Future<void> announceRecordingState(String state) async {
    await speak('Recording $state');
  }

  Future<void> announceError(String error) async {
    await speak('Error: $error');
  }

  Future<void> announceStationCount(int count) async {
    await speak('$count ${count == 1 ? 'station' : 'stations'} available');
  }

  void dispose() {
    _tts.stop();
  }
}

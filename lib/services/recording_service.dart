import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingState { idle, recording, paused }

class RecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  RecordingState _state = RecordingState.idle;
  String? _currentRecordingPath;

  RecordingState get state => _state;
  String? get currentRecordingPath => _currentRecordingPath;

  Future<bool> requestPermissions() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording(String stationName) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      throw Exception('Microphone permission not granted');
    }

    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${stationName.replaceAll(' ', '_')}_$timestamp.m4a';
    _currentRecordingPath = '${recordingsDir.path}/$fileName';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _currentRecordingPath!,
    );

    _state = RecordingState.recording;
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _state = RecordingState.idle;
    _currentRecordingPath = null;
    return path;
  }

  Future<void> pauseRecording() async {
    await _recorder.pause();
    _state = RecordingState.paused;
  }

  Future<void> resumeRecording() async {
    await _recorder.resume();
    _state = RecordingState.recording;
  }

  Future<List<FileSystemEntity>> getRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');
    
    if (!await recordingsDir.exists()) {
      return [];
    }

    return recordingsDir.listSync()
      ..sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
  }

  Future<void> deleteRecording(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void dispose() {
    _recorder.dispose();
  }
}

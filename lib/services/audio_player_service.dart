import 'package:just_audio/just_audio.dart';
import '../models/radio_station.dart';

enum PlayerState { stopped, playing, loading, error }

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  RadioStation? _currentStation;
  PlayerState _state = PlayerState.stopped;

  AudioPlayer get audioPlayer => _audioPlayer;
  RadioStation? get currentStation => _currentStation;
  PlayerState get state => _state;

  Stream<PlayerState> get stateStream => _audioPlayer.playerStateStream.map((state) {
    if (state.processingState == ProcessingState.loading || 
        state.processingState == ProcessingState.buffering) {
      return PlayerState.loading;
    } else if (state.playing) {
      return PlayerState.playing;
    } else {
      return PlayerState.stopped;
    }
  });

  Future<void> playStation(RadioStation station) async {
    try {
      _currentStation = station;
      _state = PlayerState.loading;
      
      await _audioPlayer.setUrl(station.url);
      await _audioPlayer.play();
      
      _state = PlayerState.playing;
    } catch (e) {
      _state = PlayerState.error;
      throw Exception('Failed to play radio station: $e');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _state = PlayerState.stopped;
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    _state = PlayerState.stopped;
  }

  Future<void> resume() async {
    await _audioPlayer.play();
    _state = PlayerState.playing;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

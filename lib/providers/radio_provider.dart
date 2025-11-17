import 'package:flutter/foundation.dart';
import '../models/radio_station.dart';
import '../services/station_manager.dart';
import '../services/audio_player_service.dart';

class RadioProvider with ChangeNotifier {
  final StationManager _stationManager;
  final AudioPlayerService _audioService = AudioPlayerService();
  
  List<RadioStation> _stations = [];
  bool _isLoading = false;
  String? _errorMessage;

  RadioProvider(this._stationManager) {
    _loadStations();
    _audioService.stateStream.listen((_) {
      notifyListeners();
    });
  }

  List<RadioStation> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RadioStation? get currentStation => _audioService.currentStation;
  PlayerState get playerState => _audioService.state;
  AudioPlayerService get audioService => _audioService;

  Future<void> _loadStations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stations = await _stationManager.getStations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load stations: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addStation(String name, String url) async {
    try {
      final station = RadioStation(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        url: url,
      );
      
      await _stationManager.addStation(station);
      await _loadStations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to add station: $e';
      notifyListeners();
    }
  }

  Future<void> updateStation(String id, String name, String url) async {
    try {
      final station = _stations.firstWhere((s) => s.id == id);
      final updated = station.copyWith(name: name, url: url);
      
      await _stationManager.updateStation(id, updated);
      await _loadStations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update station: $e';
      notifyListeners();
    }
  }

  Future<void> deleteStation(String id) async {
    try {
      if (_audioService.currentStation?.id == id) {
        await _audioService.stop();
      }
      
      await _stationManager.deleteStation(id);
      await _loadStations();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete station: $e';
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _stationManager.toggleFavorite(id);
      await _loadStations();
    } catch (e) {
      _errorMessage = 'Failed to toggle favorite: $e';
      notifyListeners();
    }
  }

  Future<void> playStation(RadioStation station) async {
    try {
      await _audioService.playStation(station);
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to play station: $e';
      notifyListeners();
    }
  }

  Future<void> stopPlayback() async {
    await _audioService.stop();
    notifyListeners();
  }

  Future<void> pausePlayback() async {
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> resumePlayback() async {
    await _audioService.resume();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}

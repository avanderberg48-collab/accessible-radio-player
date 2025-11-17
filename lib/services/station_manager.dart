import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/radio_station.dart';

class StationManager {
  static const String _stationsKey = 'radio_stations';
  final SharedPreferences _prefs;

  StationManager(this._prefs);

  static Future<StationManager> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StationManager(prefs);
  }

  Future<List<RadioStation>> getStations() async {
    final String? stationsJson = _prefs.getString(_stationsKey);
    if (stationsJson == null) {
      return _getDefaultStations();
    }
    
    try {
      final List<dynamic> decoded = json.decode(stationsJson);
      return decoded.map((item) => RadioStation.fromJson(item)).toList();
    } catch (e) {
      return _getDefaultStations();
    }
  }

  Future<void> saveStations(List<RadioStation> stations) async {
    final String encoded = json.encode(stations.map((s) => s.toJson()).toList());
    await _prefs.setString(_stationsKey, encoded);
  }

  Future<void> addStation(RadioStation station) async {
    final stations = await getStations();
    stations.add(station);
    await saveStations(stations);
  }

  Future<void> updateStation(String id, RadioStation updatedStation) async {
    final stations = await getStations();
    final index = stations.indexWhere((s) => s.id == id);
    if (index != -1) {
      stations[index] = updatedStation;
      await saveStations(stations);
    }
  }

  Future<void> deleteStation(String id) async {
    final stations = await getStations();
    stations.removeWhere((s) => s.id == id);
    await saveStations(stations);
  }

  Future<void> toggleFavorite(String id) async {
    final stations = await getStations();
    final index = stations.indexWhere((s) => s.id == id);
    if (index != -1) {
      stations[index] = stations[index].copyWith(
        isFavorite: !stations[index].isFavorite,
      );
      await saveStations(stations);
    }
  }

  List<RadioStation> _getDefaultStations() {
    return [
      RadioStation(
        id: '1',
        name: 'BBC Radio 1',
        url: 'http://stream.live.vc.bbcmedia.co.uk/bbc_radio_one',
      ),
      RadioStation(
        id: '2',
        name: 'NPR News',
        url: 'https://npr-ice.streamguys1.com/live.mp3',
      ),
    ];
  }
}

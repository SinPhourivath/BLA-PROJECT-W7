import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/ride/ride_pref.dart';
import '../../dto/ride_preferences_dto.dart';

class LocalRidePreferencesRepository {
  static const String _preferencesKey = 'ride_preferences';

  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Get the string list form the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    // Convert the string list to a list of RidePreferences – Using map()
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addPastPreference(RidePreference preference) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPreferences = await getPastPreferences();

    // Remove the old one and add the new preference
    existingPreferences.remove(preference);
    existingPreferences.add(preference);

    // Save the new list as a string list
    await prefs.setStringList(
      _preferencesKey,
      existingPreferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }
}

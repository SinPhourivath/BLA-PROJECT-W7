import 'package:flutter/material.dart';
import 'package:week7/model/ride/ride_pref.dart';
import 'package:week7/repository/rides_repository.dart';

import '../../model/ride/ride.dart';
import '../../model/ride/ride_filter.dart';
import '../../repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;

  final RidePreferencesRepository repository;
  final RidesRepository ridesRepository;

  late AsyncValue<List<RidePreference>> pastPreferences;

  RidesPreferencesProvider({
    required this.repository,
    required this.ridesRepository,
  }) {
    _fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // set a new preference only if it's different from the current one
    if (_currentPreference == pref) {
      return;
    }
    _currentPreference = pref;

    // add new preference to past preference list
    _addPreference(pref);
    notifyListeners();
  }

  List<Ride> getRidesFor(RidePreference pref, RideFilter? filter) {
    return ridesRepository.getRidesFor(pref, filter);
  }

  Future<void> _fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences();
      pastPreferences = AsyncValue.success(pastPrefs);
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
    }

    notifyListeners();
  }

  Future<void> _addPreference(RidePreference ridePrefs) async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      await repository.addPreference(ridePrefs);
      await _fetchPastPreferences();
    } catch (error) {
      pastPreferences = AsyncValue.error(error);
      notifyListeners();
    }
  }

  // I choose the fisrt approch to handle the data change in the database because:
  // - make additional network call but easier to implement
  // - ensure data consistancy betweeen backend database
  // - in other case, data usually get the id assigned at the backend and so we might need the id immediately
}

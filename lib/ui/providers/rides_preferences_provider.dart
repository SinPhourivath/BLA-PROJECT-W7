import 'package:flutter/material.dart';
import 'package:week7/model/ride/ride_pref.dart';
import 'package:week7/repository/rides_repository.dart';

import '../../model/ride/ride.dart';
import '../../model/ride/ride_filter.dart';
import '../../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference;
  final List<RidePreference> _pastPreferences = [];

  final RidePreferencesRepository repository;
  final RidesRepository ridesRepository;

  RidesPreferencesProvider(
      {required this.repository, required this.ridesRepository}) {
    _pastPreferences.addAll(repository.getPastPreferences());
  }

  RidePreference? get currentPreference => _currentPreference;

  void setCurrentPreference(RidePreference pref) {
    // set a new preference only if it's different from the current one
    if (_currentPreference == pref) {
      return;
    }
    _currentPreference = pref;

    // add new preference to past preference list
    _pastPreferences.remove(pref); // remove the old one if exists
    _pastPreferences.add(pref);
    notifyListeners();
  }

  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

  List<Ride> getRidesFor(RidePreference pref, RideFilter? filter) {
    return ridesRepository.getRidesFor(pref, filter); // no rides for now
  }
}

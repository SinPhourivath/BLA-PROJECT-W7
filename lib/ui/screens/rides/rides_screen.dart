import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import '../../providers/rides_preferences_provider.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../service/ride_prefs_service.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  RidesScreen({super.key});

  final RideFilter currentFilter = RideFilter();

  void onBackPressed(BuildContext context) {
    // Back to the previous view
    Navigator.of(context).pop();
  }

  // onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
  //   final ridesPreferencesProvider =
  //       Provider.of<RidesPreferencesProvider>(context, listen: false);

  //   ridesPreferencesProvider.setCurrentPreference(newPreference);
  // }

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    final ridesPreferencesProvider =
        Provider.of<RidesPreferencesProvider>(context, listen: false);

    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // Update the current preference
      ridesPreferencesProvider.setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    final ridePreferenceProdvider =
        Provider.of<RidesPreferencesProvider>(context);
    final RidePreference? currentRidePreference =
        ridePreferenceProdvider.currentPreference;

    final List<Ride> matchingRides = ridePreferenceProdvider.getRidesFor(
        currentRidePreference!, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentRidePreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentRidePreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

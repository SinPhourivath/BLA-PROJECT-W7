import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7/data/repository/local/local_ride_preferences_repository.dart';
import 'package:week7/data/repository/mock/mock_rides_repository.dart';
import 'package:week7/ui/providers/rides_preferences_provider.dart';

class ProviderScope extends StatelessWidget {
  const ProviderScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RidesPreferencesProvider(
            repository: LocalRidePreferencesRepository(),
            ridesRepository: MockRidesRepository(),
          ),
        )
      ],
      child: child,
    );
  }
}

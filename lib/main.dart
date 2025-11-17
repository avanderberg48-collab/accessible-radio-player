import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/radio_provider.dart';
import 'services/station_manager.dart';
import 'services/accessibility_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final stationManager = await StationManager.create();
  final accessibilityService = AccessibilityService();
  
  runApp(MyApp(
    stationManager: stationManager,
    accessibilityService: accessibilityService,
  ));
}

class MyApp extends StatelessWidget {
  final StationManager stationManager;
  final AccessibilityService accessibilityService;

  const MyApp({
    super.key,
    required this.stationManager,
    required this.accessibilityService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RadioProvider(stationManager),
        ),
        Provider<AccessibilityService>.value(
          value: accessibilityService,
        ),
      ],
      child: MaterialApp(
        title: 'Accessible Radio Player',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 16),
            titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 18),
            bodyMedium: TextStyle(fontSize: 16),
            titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

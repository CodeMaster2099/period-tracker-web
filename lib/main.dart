import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'app_theme.dart';
import 'state/tracker_state.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  if (!kIsWeb) {
    try {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    } catch (_) {}
  }
  runApp(const PeriodTrackerApp());
}

class PeriodTrackerApp extends StatelessWidget {
  const PeriodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TrackerState(),
      child: MaterialApp(
        title: 'Period Tracker',
        theme: buildTheme(),
        home: const OnboardingScreen(),
      ),
    );
  }
}

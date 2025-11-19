import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/tracker_state.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your wellness anchor', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            const Text('Track cycles, symptoms, moods, and get gentle reminders—all stored privately on your device.'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: () async {
                    await context.read<TrackerState>().load();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                    }
                  },
                child: const Text('Get started'),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

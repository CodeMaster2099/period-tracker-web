import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/tracker_state.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<TrackerState>().entries;
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total entries: ${entries.length}'),
            const SizedBox(height: 12),
            const Text('Simple insights placeholder...'),
          ],
        ),
      ),
    );
  }
}

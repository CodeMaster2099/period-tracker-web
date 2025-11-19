import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/tracker_state.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/stat_card.dart';
import 'add_entry_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TrackerState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Period Tracker'),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InsightsScreen())), icon: const Icon(Icons.insights)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())), icon: const Icon(Icons.settings)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEntryScreen())),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => state.load(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CalendarWidget(
              entries: state.entries,
              onTapDay: (date) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AddEntryScreen(prefilledDate: date)));
              },
            ),
            const SizedBox(height: 8),
            StatCard(title: 'Next period', value: fmtDate(state.nextPeriod), icon: Icons.calendar_today),
            StatCard(title: 'Ovulation (approx)', value: fmtDate(state.ovulation), icon: Icons.water_drop),
            if (state.fertileWindow != null)
              StatCard(
                title: 'Fertile window',
                value: '${fmtDate(state.fertileWindow!.$1)} – ${fmtDate(state.fertileWindow!.$2)}',
                icon: Icons.local_florist,
              ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Recent logs', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final e in state.entries.take(8))
                    ListTile(
                      leading: CircleAvatar(child: Text('${e.date.day}')),
                      title: Text('${e.isPeriodDay ? 'Period' : 'Day'} • Flow ${e.flow}'),
                      subtitle: Text([
                        if (e.mood != null) 'Mood: ${e.mood}',
                        if (e.symptoms.isNotEmpty) 'Symptoms: ${e.symptoms.join(', ')}',
                        if ((e.notes ?? '').isNotEmpty) 'Notes: ${e.notes}',
                      ].join(' • ')),
                      trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => context.read<TrackerState>().deleteEntry(e.id!)),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

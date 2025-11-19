import 'package:flutter/material.dart';
 
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Daily reminder'),
            subtitle: const Text('Gentle nudge to log your day'),
            value: _reminderEnabled,
            onChanged: (v) async {
              setState(() => _reminderEnabled = v);
              if (!v) await NotificationService().cancelAll();
            },
          ),
          ListTile(
            title: const Text('Reminder time'),
            subtitle: Text('${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}'),
            trailing: const Icon(Icons.schedule),
            onTap: () async {
              final picked = await showTimePicker(context: context, initialTime: _reminderTime);
              if (picked != null) setState(() => _reminderTime = picked);
            },
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              if (!_reminderEnabled) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enable reminders first')));
                return;
              }
              final now = DateTime.now();
              final when = DateTime(now.year, now.month, now.day, _reminderTime.hour, _reminderTime.minute).add(const Duration(minutes: 1));
              await NotificationService().scheduleReminder(when, title: 'Log your day', body: 'How are you feeling? Add today’s entry.');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder scheduled')));
              }
            },
            child: const Text('Schedule next reminder'),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Privacy: Your data is stored locally on your device. This app does not upload your entries unless you add cloud sync later.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

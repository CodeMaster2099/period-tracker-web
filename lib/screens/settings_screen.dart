import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/file_export.dart';

import '../services/notification_service.dart';
import '../state/tracker_state.dart';

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
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Data export/import'),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final json = await context.read<TrackerState>().exportData();
                    // Try save to file; on web this triggers download, on IO it writes to CWD.
                    try {
                      final filename = await saveFile(json, filename: 'pt_export.json');
                      messenger.showSnackBar(SnackBar(content: Text('Export saved: $filename')));
                    } catch (_) {
                      await Clipboard.setData(ClipboardData(text: json));
                      messenger.showSnackBar(const SnackBar(content: Text('Export copied to clipboard')));
                    }
                  },
                  child: const Text('Export (download file)'),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    // Use FilePicker to select a JSON file and import
                    try {
                      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json'], withData: true);
                      if (result != null && result.files.isNotEmpty) {
                        final bytes = result.files.first.bytes;
                        if (bytes != null) {
                          final content = String.fromCharCodes(bytes);
                          await context.read<TrackerState>().importData(content);
                          messenger.showSnackBar(const SnackBar(content: Text('Import complete')));
                        }
                      }
                    } catch (e) {
                      messenger.showSnackBar(const SnackBar(content: Text('Import failed')));
                    }
                  },
                  child: const Text('Import (choose file)'),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

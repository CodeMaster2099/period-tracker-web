import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/symptom.dart';
import '../models/mood.dart';
import '../models/cycle_entry.dart';
import '../state/tracker_state.dart';
import '../widgets/symptom_chip.dart';
import '../widgets/mood_chip.dart';

class AddEntryScreen extends StatefulWidget {
  final DateTime? prefilledDate;
  const AddEntryScreen({super.key, this.prefilledDate});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  late DateTime _date;
  int _flow = 0;
  final Set<String> _symptoms = {};
  String? _mood;
  final TextEditingController _notes = TextEditingController();
  bool _isPeriodDay = false;

  @override
  void initState() {
    super.initState();
    _date = widget.prefilledDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add log')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date'),
            subtitle: Text('${_date.toLocal()}'.split(' ').first),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Mark as period day'),
            value: _isPeriodDay,
            onChanged: (v) => setState(() => _isPeriodDay = v),
          ),
          const SizedBox(height: 8),
          const Text('Flow'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: List.generate(4, (i) {
              final labels = ['None', 'Light', 'Medium', 'Heavy'];
              return ChoiceChip(
                label: Text(labels[i]),
                selected: _flow == i,
                selectedColor: scheme.primary.withOpacity(0.25),
                onSelected: (_) => setState(() => _flow = i),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text('Symptoms'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              for (final s in defaultSymptoms)
                SymptomChip(
                  label: s.label,
                  selected: _symptoms.contains(s.key),
                  onTap: () {
                    setState(() {
                      if (_symptoms.contains(s.key)) {
                        _symptoms.remove(s.key);
                      } else {
                        _symptoms.add(s.key);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Mood'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              for (final m in defaultMoods)
                MoodChip(
                  label: m.label,
                  selected: _mood == m.key,
                  onTap: () => setState(() => _mood = m.key),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Notes'),
          const SizedBox(height: 6),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Optional notes'),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            onPressed: () async {
              final entry = CycleEntry(
                date: _date,
                flow: _flow,
                symptoms: _symptoms.toList(),
                mood: _mood,
                notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                isPeriodDay: _isPeriodDay,
              );
              await context.read<TrackerState>().addEntry(entry);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

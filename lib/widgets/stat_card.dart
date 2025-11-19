import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({super.key, required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: scheme.primary.withOpacity(0.1), child: Icon(icon, color: scheme.primary)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 16)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

String fmtDate(DateTime? d) => d == null ? '—' : DateFormat.yMMMd().format(d);

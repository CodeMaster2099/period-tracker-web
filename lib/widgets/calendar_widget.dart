import 'package:flutter/material.dart';
import '../models/cycle_entry.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final List<CycleEntry> entries;
  final void Function(DateTime date) onTapDay;

  const CalendarWidget({super.key, required this.entries, required this.onTapDay});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);

    Set<String> periodDates = entries.where((e) => e.isPeriodDay).map((e) => DateFormat('yyyy-MM-dd').format(e.date)).toSet();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat.yMMMM().format(now), style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 6, crossAxisSpacing: 6),
            itemCount: daysInMonth,
            itemBuilder: (ctx, i) {
              final d = start.add(Duration(days: i));
              final key = DateFormat('yyyy-MM-dd').format(d);
              final isPeriod = periodDates.contains(key);
              return InkWell(
                onTap: () => onTapDay(d),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isPeriod ? Theme.of(context).colorScheme.secondary.withOpacity(0.35) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('${d.day}', style: TextStyle(fontWeight: FontWeight.w600, color: isPeriod ? Colors.black : Colors.grey.shade800)),
                ),
              );
            },
          ),
        ]),
      ),
    );
  }
}

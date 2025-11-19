import 'dart:math';
import '../models/cycle_entry.dart';

class PredictionService {
  // Simple average cycle length based on last 6 period starts; fallback 28
  Future<int> estimateCycleLength(List<CycleEntry> periodStarts) async {
    if (periodStarts.length < 2) return 28;
    // Sort by date ascending
    final sorted = periodStarts.toList()..sort((a, b) => a.date.compareTo(b.date));
    final lengths = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      lengths.add(sorted[i].date.difference(sorted[i - 1].date).inDays);
    }
    if (lengths.isEmpty) return 28;
    final lastSix = lengths.take(6).toList();
    final avg = lastSix.reduce((a, b) => a + b) / lastSix.length;
    return max(21, min(35, avg.round()));
  }

  // Predict next period based on last start + avg length
  DateTime predictNextPeriod(DateTime lastStart, int cycleLength) {
    return lastStart.add(Duration(days: cycleLength));
  }

  // Ovulation ~14 days before next period (simple approximation)
  DateTime predictOvulation(DateTime nextPeriod) {
    return nextPeriod.subtract(const Duration(days: 14));
  }

  // Fertile window: ovulation -4 to +1 days
  ({DateTime start, DateTime end}) fertileWindow(DateTime ovulation) {
    return (start: ovulation.subtract(const Duration(days: 4)), end: ovulation.add(const Duration(days: 1)));
  }
}

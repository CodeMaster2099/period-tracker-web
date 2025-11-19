import 'package:flutter/foundation.dart';
import '../models/cycle_entry.dart';
import '../services/db_service.dart';
import '../services/prediction_service.dart';

class TrackerState extends ChangeNotifier {
  final _db = DbService();
  final _pred = PredictionService();

  List<CycleEntry> _entries = [];
  bool _loaded = false;

  List<CycleEntry> get entries => _entries;
  bool get loaded => _loaded;

  DateTime? _nextPeriod;
  DateTime? get nextPeriod => _nextPeriod;

  DateTime? _ovulation;
  DateTime? get ovulation => _ovulation;

  (DateTime, DateTime)? _fertileWindow;
  (DateTime, DateTime)? get fertileWindow => _fertileWindow;

  Future<void> load() async {
    _entries = await _db.getEntries();
    await _computePredictions();
    _loaded = true;
    notifyListeners();
  }

  Future<void> addEntry(CycleEntry entry) async {
    await _db.insertEntry(entry);
    await load();
  }

  Future<void> deleteEntry(int id) async {
    await _db.deleteEntry(id);
    await load();
  }

  Future<void> _computePredictions() async {
    final periodStarts = await _db.getPeriodDays();
    if (periodStarts.isEmpty) {
      _nextPeriod = null;
      _ovulation = null;
      _fertileWindow = null;
      return;
    }
    final lastStart = periodStarts.first.date;
    final avgLen = await _pred.estimateCycleLength(periodStarts);
    final predicted = _pred.predictNextPeriod(lastStart, avgLen);
    _nextPeriod = predicted;
    final ovu = _pred.predictOvulation(predicted);
    _ovulation = ovu;
    final fw = _pred.fertileWindow(ovu);
    _fertileWindow = (fw.start, fw.end);
  }
}

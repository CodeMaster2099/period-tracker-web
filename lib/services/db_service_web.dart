// Web-friendly DbService that stores entries in window.localStorage as JSON.
import 'dart:convert';
import 'dart:html' as html;
import '../models/cycle_entry.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  static const _storageKey = 'pt_cycle_entries_v1';
  List<CycleEntry>? _cache;

  Future<void> _ensureLoaded() async {
    if (_cache != null) return;
    final raw = html.window.localStorage[_storageKey];
    if (raw == null) {
      _cache = [];
      return;
    }
    try {
      final list = json.decode(raw) as List<dynamic>;
      _cache = list.map((e) => CycleEntry.fromMap(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      _cache = [];
    }
  }

  Future<void> _save() async {
    if (_cache == null) return;
    final list = _cache!.map((e) => e.toMap()).toList();
    html.window.localStorage[_storageKey] = json.encode(list);
  }

  Future<int> insertEntry(CycleEntry entry) async {
    await _ensureLoaded();
    final nextId = (_cache!.map((e) => e.id ?? 0).fold<int>(0, (p, n) => p > n ? p : n)) + 1;
    final toInsert = CycleEntry(
      id: nextId,
      date: entry.date,
      flow: entry.flow,
      symptoms: entry.symptoms,
      mood: entry.mood,
      notes: entry.notes,
      isPeriodDay: entry.isPeriodDay,
    );
    _cache!.insert(0, toInsert);
    await _save();
    return toInsert.id!;
  }

  Future<List<CycleEntry>> getEntries() async {
    await _ensureLoaded();
    _cache!.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(_cache!);
  }

  Future<void> deleteEntry(int id) async {
    await _ensureLoaded();
    _cache!.removeWhere((e) => e.id == id);
    await _save();
  }

  Future<void> updateEntry(CycleEntry entry) async {
    await _ensureLoaded();
    final idx = _cache!.indexWhere((e) => e.id == entry.id);
    if (idx != -1) {
      _cache![idx] = entry;
      await _save();
    }
  }

  Future<CycleEntry?> getLastPeriodStart() async {
    await _ensureLoaded();
    final list = _cache!.where((e) => e.isPeriodDay).toList();
    if (list.isEmpty) return null;
    list.sort((a, b) => b.date.compareTo(a.date));
    return list.first;
  }

  Future<List<CycleEntry>> getPeriodDays() async {
    await _ensureLoaded();
    final list = _cache!.where((e) => e.isPeriodDay).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}

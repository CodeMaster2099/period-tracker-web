class CycleEntry {
  final int? id;
  final DateTime date;
  final int flow; // 0 none, 1 light, 2 medium, 3 heavy
  final List<String> symptoms; // e.g., cramps, bloating
  final String? mood; // e.g., calm, anxious
  final String? notes;
  final bool isPeriodDay;

  CycleEntry({
    this.id,
    required this.date,
    required this.flow,
    required this.symptoms,
    this.mood,
    this.notes,
    required this.isPeriodDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'flow': flow,
      'symptoms': symptoms.join(','),
      'mood': mood,
      'notes': notes,
      'isPeriodDay': isPeriodDay ? 1 : 0,
    };
  }

  factory CycleEntry.fromMap(Map<String, dynamic> map) {
    return CycleEntry(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      flow: map['flow'] as int,
      symptoms: (map['symptoms'] as String?)
              ?.split(',').where((e) => e.isNotEmpty).toList() ?? [],
      mood: map['mood'] as String?,
      notes: map['notes'] as String?,
      isPeriodDay: (map['isPeriodDay'] as int) == 1,
    );
  }
}

class Mood {
  final String key;
  final String label;
  const Mood(this.key, this.label);
}

const defaultMoods = <Mood>[
  Mood('calm', 'Calm'),
  Mood('energized', 'Energized'),
  Mood('moody', 'Moody'),
  Mood('anxious', 'Anxious'),
  Mood('sad', 'Sad'),
  Mood('focus', 'Focused'),
];

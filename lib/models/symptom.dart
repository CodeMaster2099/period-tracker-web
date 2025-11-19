class Symptom {
  final String key;
  final String label;

  const Symptom(this.key, this.label);
}

const defaultSymptoms = <Symptom>[
  Symptom('cramps', 'Cramps'),
  Symptom('bloating', 'Bloating'),
  Symptom('headache', 'Headache'),
  Symptom('fatigue', 'Fatigue'),
  Symptom('back_pain', 'Back pain'),
  Symptom('acne', 'Acne'),
  Symptom('breast_tenderness', 'Breast tenderness'),
];

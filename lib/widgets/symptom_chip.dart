import 'package:flutter/material.dart';

class SymptomChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SymptomChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: scheme.secondary.withOpacity(0.25),
    );
  }
}

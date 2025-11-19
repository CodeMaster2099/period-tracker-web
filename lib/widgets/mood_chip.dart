import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const MoodChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: scheme.primary.withOpacity(0.25),
    );
  }
}

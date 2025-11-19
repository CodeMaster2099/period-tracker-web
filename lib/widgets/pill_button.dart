import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final IconData? icon;

  const PillButton({super.key, required this.label, required this.onTap, this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color ?? scheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 18, color: scheme.primary),
            if (icon != null) const SizedBox(width: 8),
            Text(label, style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

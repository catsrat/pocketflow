import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback? onTap;
  final bool selected;
  const CategoryChip({
    required this.name,
    required this.color,
    this.onTap,
    this.selected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? color.withOpacity(0.18) : Colors.white;
    final borderColor = selected ? color : Colors.grey.shade200;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
          boxShadow: selected ? [BoxShadow(color: color.withOpacity(0.08), blurRadius: 12, offset: const Offset(0,6))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
              alignment: Alignment.center,
              child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(width: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

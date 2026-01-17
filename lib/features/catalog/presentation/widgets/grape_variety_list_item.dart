import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/grape_variety.dart';

class GrapeVarietyListItem extends StatelessWidget {
  final GrapeVariety grapeVariety;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const GrapeVarietyListItem({
    super.key,
    required this.grapeVariety,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasOrigin = grapeVariety.originRegion != null && grapeVariety.originRegion!.isNotEmpty;

    return InkWell(
      onTap: () {
        onChanged(!isSelected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Уменьшаем вертикальный padding
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(grapeVariety.name ?? 'Название отсутствует'),
                  if (hasOrigin)
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0), // Маленький отступ для subtitle
                      child: Text(
                        grapeVariety.originRegion!,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
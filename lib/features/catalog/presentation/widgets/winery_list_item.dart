import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

class WineryListItem extends StatelessWidget {
  final Winery winery;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;

  const WineryListItem({
    super.key,
    required this.winery,
    required this.isSelected,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (winery.logoUrl != null && winery.logoUrl!.isNotEmpty)
                    ? Image.network(
                        winery.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Плейсхолдер в случае ошибки загрузки
                          return const Icon(Icons.business, color: Colors.grey);
                        },
                      )
                    : const Icon(Icons.business, color: Colors.grey), // Плейсхолдер, если URL пуст
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                winery.name ?? 'Имя не указано',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
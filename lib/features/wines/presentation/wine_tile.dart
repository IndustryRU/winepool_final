import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/offers/application/offers_controller.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/widgets/wine_characteristic_icons.dart';

class WineTile extends ConsumerWidget {
  final Wine wine;
  final bool isSearch;

  const WineTile({super.key, required this.wine, this.isSearch = false});

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    // Используем провайдер для получения диапазона цен
    final priceRangeAsync = wine.id != null 
        ? ref.watch(winePriceRangeProviderProvider(wine.id!)) 
        : const AsyncValue.data(null);
    
    return SizedBox(
      height: 150, // Увеличиваем высоту всего виджета
      child: Card(
        elevation: 0, // Убираем тень у карточки вина
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Opacity(
            opacity: wine.isDeleted == true ? 0.5 : 1.0, // Уменьшаем прозрачность для удаленных элементов
            child: Row(
              children: [
                if (wine.imageUrl != null && wine.imageUrl!.isNotEmpty)
                  Container(
                    width: 60,
                    height: 140, // Возвращаем высоту фото к 90
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(wine.imageUrl!),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 140, // Возвращаем высоту фото к 90
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.wine_bar,
                      color: Colors.grey,
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое по вертикали
                    children: [
                      if (wine.isDeleted == true) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              wine.name ?? 'Название не указано',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          wine.name ?? 'Название не указано',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      Text(
                        wine.winery?.name ?? (wine.wineryId != null ? wine.wineryId! : 'Без винодельни'), // Здесь должно быть название винодельни, а не ID
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (wine.grapeVarieties != null && wine.grapeVarieties!.isNotEmpty)
                        Text(
                          wine.grapeVarieties!.map((g) => g.name).join(', '),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      WineCharacteristicIconsColumn(wine: wine, iconSize: 16.0, isSearch: isSearch),
                      Row(
                        children: [
                          Expanded(
                            child: priceRangeAsync.when(
                              data: (priceRange) {
                                String priceInfo = 'Цена не указана';
                                
                                if (priceRange != null) {
                                  final (minPrice, maxPrice) = priceRange;
                                  
                                  if (minPrice == maxPrice) {
                                    priceInfo = '${minPrice.toStringAsFixed(0)} ₽';
                                  } else {
                                    priceInfo = 'от ${minPrice.toStringAsFixed(0)} до ${maxPrice.toStringAsFixed(0)} ₽';
                                  }
                                } else {
                                  priceInfo = 'Цена не указана';
                                }
                                
                                return Text(
                                  priceInfo,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                              loading: () => const Text(
                                'Загрузка...',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              error: (error, stack) => Text(
                                'Ошибка загрузки цен',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          if (wine.averageRating != null)
                            Text(
                              '${wine.averageRating} ★',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
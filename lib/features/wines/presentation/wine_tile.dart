import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/widgets/wine_characteristic_icons.dart';

class WineTile extends StatelessWidget {
  final Wine wine;
  final bool isSearch;

  const WineTile({super.key, required this.wine, this.isSearch = false});

  @override
 Widget build(BuildContext context) {
    print(wine.winery);
    
    // Используем min_price и max_price из модели Wine
    String priceInfo = '';
    if (wine.minPrice != null && wine.maxPrice != null) {
      if (wine.minPrice == wine.maxPrice) {
        priceInfo = '${wine.minPrice!.toStringAsFixed(0)} ₽';
      } else {
        priceInfo = 'от ${wine.minPrice!.toStringAsFixed(0)} до ${wine.maxPrice!.toStringAsFixed(0)} ₽';
      }
    } else {
      priceInfo = 'Цена не указана';
    }

    return SizedBox(
      height: 150, // Увеличиваем высоту всего виджета
      child: Card(
        elevation: 0, // Убираем тень у карточки вина
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    Text(
                      wine.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      wine.winery?.name ?? (wine.wineryId != null ? wine.wineryId! : 'Без винодельни'), // Здесь должно быть название винодельни, а не ID
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    WineCharacteristicIconsColumn(wine: wine, iconSize: 16.0, isSearch: isSearch),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            priceInfo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
    );
 }
}
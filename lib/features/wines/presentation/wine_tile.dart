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
    
    // Вычисляем минимальную и максимальную цену из предложений
    String priceInfo = '';
    if (wine.offers != null && wine.offers!.isNotEmpty) {
      final prices = wine.offers!.map((offer) => offer.price ?? 0).toList();
      prices.removeWhere((price) => price == 0); // Убираем нулевые цены
      
      if (prices.isNotEmpty) {
        final minPrice = prices.reduce((a, b) => a < b ? a : b);
        final maxPrice = prices.reduce((a, b) => a > b ? a : b);
        
        if (minPrice == maxPrice) {
          priceInfo = '${minPrice.toStringAsFixed(0)} ₽';
        } else {
          priceInfo = 'от ${minPrice.toStringAsFixed(0)} до ${maxPrice.toStringAsFixed(0)} ₽';
        }
      } else {
        priceInfo = 'Цена не указана';
      }
    } else {
      priceInfo = 'Цена не указана';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (wine.imageUrl != null && wine.imageUrl!.isNotEmpty)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(wine.imageUrl!),
                  ),
                ),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
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
    );
  }
}
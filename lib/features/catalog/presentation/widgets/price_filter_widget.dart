import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PriceFilterWidget extends HookConsumerWidget {
  final ValueNotifier<Map<String, dynamic>> selectedFilters;

  const PriceFilterWidget({
    super.key,
    required this.selectedFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minPrice = selectedFilters.value['min_price'] ?? 0;
    final maxPrice = selectedFilters.value['max_price'] ?? 10000;
    final currentMinPrice = useState(minPrice);
    final currentMaxPrice = useState(maxPrice);
    
    // Обновляем состояния при изменении фильтров
    useEffect(() {
      currentMinPrice.value = selectedFilters.value['min_price'] ?? 0;
      currentMaxPrice.value = selectedFilters.value['max_price'] ?? 10000;
      return null;
    }, [selectedFilters.value['min_price'], selectedFilters.value['max_price']]);
    
    // Создаем контроллеры для текстовых полей
    final minPriceController = useTextEditingController(text: currentMinPrice.value.toString());
    final maxPriceController = useTextEditingController(text: currentMaxPrice.value.toString());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('От ${currentMinPrice.value} до ${currentMaxPrice.value}'),
        RangeSlider(
          min: 0,
          max: 10000,
          divisions: 100, // Шаг 100 руб, так как (10000-0)/100 = 100
          values: RangeValues(
            currentMinPrice.value.toDouble(),
            currentMaxPrice.value.toDouble()
          ),
          onChanged: (RangeValues values) {
            double newStart = values.start;
            double newEnd = values.end;
            
            // Проверяем, что значения находятся в допустимых пределах
            if (newEnd > 10000) {
              newEnd = 10000;
            }
            if (newStart < 0) {
              newStart = 0;
            }
            
            // Убедимся, что start не больше end
            if (newStart > newEnd) {
              newStart = newEnd;
            }
            
            // Округляем до сотен
            final newMin = (newStart ~/ 100) * 100;
            final newMax = (newEnd ~/ 100) * 100;
            
            currentMinPrice.value = newMin;
            currentMaxPrice.value = newMax;
            
            // Обновляем контроллеры
            minPriceController.text = newMin.toString();
            maxPriceController.text = newMax.toString();
            
            selectedFilters.value['min_price'] = newMin;
            selectedFilters.value['max_price'] = newMax;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Мин. цена'),
                keyboardType: TextInputType.number,
                controller: minPriceController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final val = int.tryParse(value) ?? currentMinPrice.value;
                    // Округляем до ближайшей сотни
                    final roundedVal = ((val / 10).round()) * 100;
                    currentMinPrice.value = roundedVal.clamp(0, currentMaxPrice.value - 10);
                    
                    selectedFilters.value['min_price'] = currentMinPrice.value;
                    selectedFilters.value = Map.from(selectedFilters.value);
                  }
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Макс. цена'),
                keyboardType: TextInputType.number,
                controller: maxPriceController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final val = int.tryParse(value) ?? currentMaxPrice.value;
                    // Округляем до ближайшей сотни
                    final roundedVal = ((val / 100).round()) * 100;
                    currentMaxPrice.value = roundedVal.clamp(currentMinPrice.value + 10, 10000);
                    
                    selectedFilters.value['max_price'] = currentMaxPrice.value;
                    selectedFilters.value = Map.from(selectedFilters.value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
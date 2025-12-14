import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers.dart';
import '../../../catalog/application/catalog_controller.dart';

class PriceFilterWidget extends HookConsumerWidget {
  final ValueNotifier<Map<String, dynamic>> selectedFilters;
  final Function(RangeValues)? onRangeChanged;
  final double? initialMinPrice;
  final double? initialMaxPrice;

   const PriceFilterWidget({
     super.key,
     required this.selectedFilters,
     this.onRangeChanged,
     this.initialMinPrice,
     this.initialMaxPrice,
   });

   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final supabaseClient = ref.watch(supabaseClientProvider);
     
     // Подготовим фильтры без ценовых параметров, чтобы получить актуальный диапазон
     final filtersWithoutPrice = useMemoized(() {
       final filters = Map<String, dynamic>.from(selectedFilters.value);
       filters.remove('min_price');
       filters.remove('max_price');
       return filters;
     }, [selectedFilters.value]);

     // Получаем диапазон цен из Supabase с учетом других фильтров
     final priceRangeAsync = useMemoized(
       () => supabaseClient.rpc('get_price_range', params: {'filters': filtersWithoutPrice}),
       [supabaseClient, filtersWithoutPrice],
     );
     
     final priceRange = useFuture(priceRangeAsync);

     // Обработка состояний AsyncSnapshot
     if (priceRange.connectionState == ConnectionState.waiting) {
       return const Center(child: CircularProgressIndicator());
     }
     
     if (priceRange.hasError) {
       return Center(
         child: Text('Ошибка загрузки диапазона цен: ${priceRange.error.toString()}'),
       );
     }

     if (!priceRange.hasData || priceRange.data!.isEmpty) {
       return const Center(child: Text('Нет данных о диапазоне цен'));
     }

     // Устанавливаем начальные значения диапазона цен только в состоянии data
     final data = priceRange.data!;
     final minPossiblePrice = data.isNotEmpty 
         ? (data[0]['min_price'] as num?)?.toDouble() ?? 0 
         : 0;
     final maxPossiblePrice = data.isNotEmpty 
         ? (data[0]['max_price'] as num?)?.toDouble() ?? 10000 
         : 10000;
     
     // Округляем до ближайших сотен
     final roundedMinPrice = ((minPossiblePrice / 100).floor()) * 100;
     final roundedMaxPrice = ((maxPossiblePrice / 100).ceil()) * 100;
     
     // Определим начальные значения для бегунков
     // Сначала пробуем использовать переданные параметры initialMinPrice и initialMaxPrice
     // Если они не заданы, используем значения из selectedFilters или округленные значения
     final minPriceToUse = initialMinPrice ?? (selectedFilters.value['min_price'] ?? roundedMinPrice).toDouble();
     final maxPriceToUse = initialMaxPrice ?? (selectedFilters.value['max_price'] ?? roundedMaxPrice).toDouble();
     
     // Убедимся, что значения находятся в пределах возможного диапазона
     final clampedMinPrice = minPriceToUse.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble());
     final clampedMaxPrice = maxPriceToUse.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble());

     final currentRange = useState(RangeValues(clampedMinPrice, clampedMaxPrice));
     final currentShowUnavailable = useState(selectedFilters.value['show_unavailable'] ?? false);
     
     // Сохраняем предыдущие значения для сравнения
     final prevRange = useRef<RangeValues>(RangeValues(clampedMinPrice, clampedMaxPrice));
     final prevShowUnavailable = useRef<bool?>(null);
     
     // Добавим useRef для отслеживания первого рендера
     final isFirstRender = useRef(true);

     // Обновляем состояния при изменении фильтров, но только если значения действительно изменились
     useEffect(() {
       // Пропускаем выполнение эффекта при первом рендере
       if (isFirstRender.value) {
         isFirstRender.value = false;
         return null;
       }

       final newMinPrice = (selectedFilters.value['min_price'] ?? roundedMinPrice).toDouble();
       final newMaxPrice = (selectedFilters.value['max_price'] ?? roundedMaxPrice).toDouble();
       final newShowUnavailable = selectedFilters.value['show_unavailable'] ?? false;

       bool shouldUpdate = false;
       
       // Проверяем, отличаются ли новые значения от текущих значений в стейте
       if (currentRange.value.start != newMinPrice || currentRange.value.end != newMaxPrice) {
         currentRange.value = RangeValues(newMinPrice, newMaxPrice);
         shouldUpdate = true;
         
         // Вызываем коллбэк при изменении значений
         onRangeChanged?.call(RangeValues(newMinPrice, newMaxPrice));
       }
       
       if (currentShowUnavailable.value != newShowUnavailable) {
         currentShowUnavailable.value = newShowUnavailable;
         shouldUpdate = true;
       }

       // Обновляем предыдущие значения ТОЛЬКО если произошло обновление
       if (shouldUpdate) {
         prevRange.value = RangeValues(newMinPrice, newMaxPrice);
         prevShowUnavailable.value = newShowUnavailable;
       }

       // Добавляем логику для проверки, находятся ли текущие значения в пределах нового диапазона
       final newMin = roundedMinPrice.toDouble();
       final newMax = roundedMaxPrice.toDouble();

       double clampedStart = currentRange.value.start.clamp(newMin, newMax);
       double clampedEnd = currentRange.value.end.clamp(newMin, newMax);

       if (clampedStart != currentRange.value.start || clampedEnd != currentRange.value.end) {
         currentRange.value = RangeValues(clampedStart, clampedEnd);
         onRangeChanged?.call(RangeValues(clampedStart, clampedEnd));
       }

       return null;
     }, [
       selectedFilters.value['min_price'], 
       selectedFilters.value['max_price'],
       selectedFilters.value['show_unavailable'],
       roundedMinPrice, // Добавляем в зависимости, чтобы срабатывало при изменении минимального значения диапазона
       roundedMaxPrice  // Добавляем в зависимости, чтобы срабатывало при изменении максимального значения диапазона
     ]);
     
     // Функция сброса фильтра цены
     void resetPriceFilter() {
       final newRange = RangeValues(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble());
       currentRange.value = newRange;
       
       // Обновляем только локальное состояние, не вызывая перерисовку всего экрана
       selectedFilters.value['min_price'] = roundedMinPrice.toDouble();
       selectedFilters.value['max_price'] = roundedMaxPrice.toDouble();
       selectedFilters.value = Map.from(selectedFilters.value);
       
       // Вызываем коллбэк при сбросе
       onRangeChanged?.call(newRange);
     }
     
     // Создаем контроллеры для текстовых полей
     final minPriceController = useTextEditingController(text: currentRange.value.start.toString());
     final maxPriceController = useTextEditingController(text: currentRange.value.end.toString());

     // Обработчик для RangeSlider (только для визуального обновления)
     void onPriceRangeChanged(RangeValues values) {
       // Гарантируем, что start не больше end
       final correctedValues = RangeValues(
         values.start <= values.end ? values.start : values.end,
         values.end >= values.start ? values.end : values.start,
       );

       // Округляем до сотен
       final newStart = ((correctedValues.start / 100).round()) * 100;
       final newEnd = ((correctedValues.end / 100).round()) * 100;
       
       // Убедимся, что значения находятся в допустимом диапазоне и start не больше end
       final clampedStart = newStart.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble()).toDouble();
       final clampedEnd = newEnd.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble()).toDouble();
       
       // Гарантируем, что start <= end после всех преобразований
       final finalStart = clampedStart <= clampedEnd ? clampedStart : clampedEnd;
       final finalEnd = clampedEnd >= clampedStart ? clampedEnd : clampedStart;
       
       final finalValues = RangeValues(finalStart, finalEnd);
       
       if (currentRange.value != finalValues) {
         currentRange.value = finalValues;
         // Обновляем только локальное состояние, не вызывая перерисовку всего экрана
         minPriceController.text = finalStart.toString();
         maxPriceController.text = finalEnd.toString();
         
         // Вызываем коллбэк при изменении значений
         onRangeChanged?.call(finalValues);
       }
     }

     // Обработчик для завершения изменения (теперь только обновляет локальное состояние)
     void onPriceRangeChangeEnd(RangeValues values) {
       // Гарантируем, что start не больше end
       final correctedValues = RangeValues(
         values.start <= values.end ? values.start : values.end,
         values.end >= values.start ? values.end : values.start,
       );

       // Округляем до сотен
       final newStart = ((correctedValues.start / 100).round()) * 100;
       final newEnd = ((correctedValues.end / 100).round()) * 100;
       
       // Убедимся, что значения находятся в допустимом диапазоне
       final clampedStart = newStart.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble()).toDouble();
       final clampedEnd = newEnd.clamp(roundedMinPrice.toDouble(), roundedMaxPrice.toDouble()).toDouble();
       
       // Гарантируем, что start <= end после всех преобразований
       final finalStart = clampedStart <= clampedEnd ? clampedStart : clampedEnd;
       final finalEnd = clampedEnd >= clampedStart ? clampedEnd : clampedStart;
       
       final finalValues = RangeValues(finalStart, finalEnd);
       
       if (currentRange.value != finalValues) {
         currentRange.value = finalValues;
         // Обновляем локальное состояние
         selectedFilters.value['min_price'] = finalStart;
         selectedFilters.value['max_price'] = finalEnd;
         selectedFilters.value = Map.from(selectedFilters.value);
         
         // Вызываем коллбэк при завершении изменения
         onRangeChanged?.call(finalValues);
       }
     }
     
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text('От ${currentRange.value.start.round()} до ${currentRange.value.end.round()}'),
         RangeSlider(
           min: roundedMinPrice.toDouble(),
           max: roundedMaxPrice.toDouble(),
           divisions: ((roundedMaxPrice - roundedMinPrice) / 100).toInt(), // Шаг 100 руб
           values: currentRange.value,
           onChanged: onPriceRangeChanged,
           onChangeEnd: onPriceRangeChangeEnd,
         ),
         const SizedBox(height: 16), // Исправлена ошибка - добавлен const и height вместо width
         Row(
           children: [
             Expanded(
               child: TextField(
                 decoration: const InputDecoration(labelText: 'Мин. цена'),
                 keyboardType: TextInputType.number,
                 controller: minPriceController,
                 onChanged: (value) {
                   if (value.isNotEmpty) {
                     final val = double.tryParse(value) ?? currentRange.value.start;
                     // Округляем до ближайшей сотни
                     final roundedVal = ((val / 100).round()) * 100;
                     final clampedVal = roundedVal.clamp(roundedMinPrice.toInt(), currentRange.value.end.toInt() - 10).toDouble();
                     
                     // Проверяем, действительно ли значение изменилось
                     if (currentRange.value.start != clampedVal) {
                       // Гарантируем, что новое значение start не превышает end
                       final newStart = clampedVal <= currentRange.value.end ? clampedVal : currentRange.value.end;
                       final newRange = RangeValues(newStart, currentRange.value.end);
                       currentRange.value = newRange;
                       
                       // Обновляем фильтры только если они действительно изменились
                       if (selectedFilters.value['min_price'] != newStart) {
                         selectedFilters.value['min_price'] = newStart;
                         selectedFilters.value = Map.from(selectedFilters.value);
                       }
                       
                       // Вызываем коллбэк при изменении значения
                       onRangeChanged?.call(newRange);
                     }
                   }
                 },
               ),
             ),
             const SizedBox(width: 16), // Исправлена ошибка - добавлен const и указан width
             Expanded(
               child: TextField(
                 decoration: const InputDecoration(labelText: 'Макс. цена'),
                 keyboardType: TextInputType.number,
                 controller: maxPriceController,
                 onChanged: (value) {
                   if (value.isNotEmpty) {
                     final val = double.tryParse(value) ?? currentRange.value.end;
                     // Округляем до ближайшей сотни
                     final roundedVal = ((val / 100).round()) * 100;
                     final clampedVal = roundedVal.clamp(currentRange.value.start.toInt() + 10, roundedMaxPrice.toInt()).toDouble();
                     
                     // Проверяем, действительно ли значение изменилось
                     if (currentRange.value.end != clampedVal) {
                       // Гарантируем, что новое значение end не меньше start
                       final newEnd = clampedVal >= currentRange.value.start ? clampedVal : currentRange.value.start;
                       final newRange = RangeValues(currentRange.value.start, newEnd);
                       currentRange.value = newRange;
                       
                       // Обновляем фильтры только если они действительно изменились
                       if (selectedFilters.value['max_price'] != newEnd) {
                         selectedFilters.value['max_price'] = newEnd;
                         selectedFilters.value = Map.from(selectedFilters.value);
                       }
                       
                       // Вызываем коллбэк при изменении значения
                       onRangeChanged?.call(newRange);
                     }
                   }
                 },
               ),
             ),
           ],
         ),
         CheckboxListTile(
           title: const Text('Показать "Нет в наличии"'),
           value: currentShowUnavailable.value,
           onChanged: (bool? value) {
             if (value != null) {
               // Проверяем, действительно ли значение изменилось
               if (currentShowUnavailable.value != value) {
                 currentShowUnavailable.value = value;
                 
                 // Обновляем фильтры только если они действительно изменились
                 if (selectedFilters.value['show_unavailable'] != value) {
                   selectedFilters.value['show_unavailable'] = value;
                   selectedFilters.value = Map.from(selectedFilters.value);
                 }
               }
             }
           },
         ),
       ],
     );
   }
 }
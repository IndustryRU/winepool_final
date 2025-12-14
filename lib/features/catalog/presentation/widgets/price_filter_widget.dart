import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/providers.dart';
import '../../../catalog/application/catalog_controller.dart';

class PriceFilterWidget extends HookConsumerWidget {
  final ValueNotifier<Map<String, dynamic>> selectedFilters;
  final Function(RangeValues)? onRangeChanged;
  final Function(bool)? onShowUnavailableChanged;
  final double? initialMinPrice;
  final double? initialMaxPrice;
  final bool? initialShowUnavailable;

   const PriceFilterWidget({
     super.key,
     required this.selectedFilters,
     this.onRangeChanged,
     this.onShowUnavailableChanged,
     this.initialMinPrice,
     this.initialMaxPrice,
     this.initialShowUnavailable,
   });

   @override
   Widget build(BuildContext context, WidgetRef ref) {
     // Получаем диапазон цен из нового провайдера, который игнорирует фильтр show_unavailable
     final priceRangeAsync = ref.watch(priceRangeProvider);
     
     // Обработка состояний AsyncValue
     if (priceRangeAsync.isLoading) {
       return const Center(child: CircularProgressIndicator());
     }
     
     if (priceRangeAsync.hasError) {
       return Center(
         child: Text('Ошибка загрузки диапазона цен: ${priceRangeAsync.error.toString()}'),
       );
     }
     
     if (!priceRangeAsync.hasValue || priceRangeAsync.value == null) {
       return const Center(child: Text('Нет данных о диапазоне цен'));
     }

     // Устанавливаем начальные значения диапазона цен только в состоянии data
     final data = priceRangeAsync.value!;
     final minPossiblePrice = (data['min_price'] as num?)?.toDouble() ?? 0.0;
     final maxPossiblePrice = (data['max_price'] as num?)?.toDouble() ?? 10000000.0;
     
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
     // Используем initialShowUnavailable для инициализации состояния, если он передан
     final currentShowUnavailable = useState(initialShowUnavailable ?? selectedFilters.value['show_unavailable'] ?? false);

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

       final currentStart = currentRange.value.start;
       final currentEnd = currentRange.value.end;

       // Проверяем, выходят ли текущие значения за новый диапазон
       if (currentStart < newMin || currentEnd > newMax) {
         // Только в этом случае "прижимаем" значения
         final clampedStart = currentStart.clamp(newMin, newMax);
         final clampedEnd = currentEnd.clamp(newMin, newMax);
         currentRange.value = RangeValues(clampedStart.toDouble(), clampedEnd.toDouble());
         onRangeChanged?.call(RangeValues(clampedStart.toDouble(), clampedEnd.toDouble()));
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
     final minPriceController = useTextEditingController(text: currentRange.value.start.toInt().toString());
     final maxPriceController = useTextEditingController(text: currentRange.value.end.toInt().toString());

     // useEffect для синхронизации значений RangeSlider с текстовыми полями
     useEffect(() {
       minPriceController.text = currentRange.value.start.toInt().toString();
       maxPriceController.text = currentRange.value.end.toInt().toString();
       return null;
     }, [currentRange.value]);

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
         minPriceController.text = finalStart.toInt().toString();
         maxPriceController.text = finalEnd.toInt().toString();
         
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
                     final newMin = double.tryParse(value) ?? currentRange.value.start;
                     final currentMax = currentRange.value.end;

                     if (newMin > currentMax) {
                       // Если новое мин. значение больше текущего макс.,
                       // устанавливаем оба значения равными новому мин.
                       final newRange = RangeValues(newMin, newMin);
                       currentRange.value = newRange;
                       
                       // Обновляем фильтры
                       selectedFilters.value['min_price'] = newMin;
                       selectedFilters.value['max_price'] = newMin;
                       selectedFilters.value = Map.from(selectedFilters.value);
                       
                       // Вызываем коллбэк при изменении значения
                       onRangeChanged?.call(newRange);
                     } else {
                       // Округляем до ближайшей сотни
                       final roundedVal = ((newMin / 100).round()) * 100;
                       final clampedVal = roundedVal.clamp(roundedMinPrice.toInt(), currentMax.toInt()).toDouble();
                       
                       // Проверяем, действительно ли значение изменилось
                       if (currentRange.value.start != clampedVal) {
                         // Гарантируем, что новое значение start не превышает end
                         final newStart = clampedVal <= currentMax ? clampedVal : currentMax;
                         final newRange = RangeValues(newStart, currentMax);
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
                     final newMax = double.tryParse(value) ?? currentRange.value.end;
                     final currentMin = currentRange.value.start;

                     if (newMax < currentMin) {
                       // Если новое макс. значение меньше текущего мин.,
                       // устанавливаем оба значения равными новому макс.
                       final newRange = RangeValues(newMax, newMax);
                       currentRange.value = newRange;
                       
                       // Обновляем фильтры
                       selectedFilters.value['min_price'] = newMax;
                       selectedFilters.value['max_price'] = newMax;
                       selectedFilters.value = Map.from(selectedFilters.value);
                       
                       // Вызываем коллбэк при изменении значения
                       onRangeChanged?.call(newRange);
                     } else {
                       // Округляем до ближайшей сотни
                       final roundedVal = ((newMax / 100).round()) * 100;
                       final clampedVal = roundedVal.clamp(currentMin.toInt(), roundedMaxPrice.toInt()).toDouble();
                       
                       // Проверяем, действительно ли значение изменилось
                       if (currentRange.value.end != clampedVal) {
                         // Гарантируем, что новое значение end не меньше start
                         final newEnd = clampedVal >= currentMin ? clampedVal : currentMin;
                         final newRange = RangeValues(currentMin, newEnd);
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
                 
                 // Вызываем колбэк при изменении значения
                 onShowUnavailableChanged?.call(value);
               }
             }
           },
         ),
       ],
     );
   }
 }
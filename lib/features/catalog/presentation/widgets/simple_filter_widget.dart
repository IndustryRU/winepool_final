import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'filter_option_list_item.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/wines/presentation/widgets/simple_characteristic_icons.dart';
import 'package:winepool_final/features/offers/domain/bottle_size.dart';

class SimpleFilterWidget extends HookConsumerWidget {
 final String title;
     final List<dynamic> allOptions;
    final List<dynamic> selectedOptions;
    final Function(List<dynamic>) onApply;

    const SimpleFilterWidget({
      Key? key,
      required this.title,
      required this.allOptions,
      required this.selectedOptions,
      required this.onApply,
    }) : super(key: key);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final temporarySelected = useState<List<dynamic>>([...selectedOptions]);

      return Column(
        children: [
          // Ручка для смахивания
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Заголовок и кнопки
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    temporarySelected.value = [];
                  },
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () {
                    onApply(temporarySelected.value);
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
          // Список опций
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: allOptions.length,
                itemBuilder: (context, index) {
                  final option = allOptions[index];
                  final isSelected = temporarySelected.value.contains(option);

                  Widget leadingWidget;
                  String title;

                  if (option is WineColor) {
                    leadingWidget = SimpleColorIcon(color: option, size: 24);
                    title = option.nameRu;
                  } else if (option is WineSugar) {
                    leadingWidget = SimpleSugarIcon(sugar: option, size: 24);
                    title = option.nameRu;
                  } else if (option is WineType) {
                    leadingWidget = SimpleWineTypeIcon(type: option, size: 24);
                    title = option.nameRu;
                  } else if (option is int) {
                    leadingWidget = VintageIcon(vintage: option, size: 24);
                    title = option.toString();
                  } else if (option is BottleSize) {
                    leadingWidget = const SizedBox(width: 24); // Нет иконки
                    title = '${option.sizeMl} мл';
                  } else {
                    leadingWidget = const SizedBox(width: 24); // Заглушка
                    title = option.toString();
                  }

                  return FilterOptionListItem(
                    leading: leadingWidget,
                    title: title,
                    isSelected: isSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        if (!temporarySelected.value.contains(option)) {
                          temporarySelected.value = [...temporarySelected.value, option];
                        }
                      } else {
                        temporarySelected.value = 
                          temporarySelected.value.where((element) => element != option).toList();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
  }
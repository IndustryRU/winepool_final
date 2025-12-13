import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Widget buildGrapeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  // Получаем список всех сортов
  final allGrapes = [
    'Каберне Совиньон',
    'Пино Нуар',
    'Шардоне',
    'Совиньон Блан',
    'Мерло',
    'Каберне Фран',
    'Сира',
    'Гевюрцтраминер',
    'Рислинг',
    'Мальбек',
    'Сангровезе',
    'Темпранильо',
    'Гарнача',
    'Монепульяна',
    'Карменере',
    'Вионье',
    'Шенен Блан',
    'Пино Гриджио',
    'Харнат',
    'Гренаш',
    'Сираз',
    'Петит Вердо',
    'Цвайгельт',
    'Мускат',
    'Траминер',
    'Шираз',
    'Мулled Вино',
    'Мускатель',
    'Порто',
    'Хеннени',
    'Алиготе',
    'Каберне Совиньон',
    'Пино Нуар',
    'Шардоне',
    'Совиньон Блан',
    'Мерло',
    'Каберне Фран',
    'Сира',
    'Гевюрцтраминер',
    'Рислинг',
    'Мальбек',
    'Сангровезе',
    'Темпранильо',
    'Гарнача',
    'Монепульяна',
    'Карменере',
    'Вионье',
    'Шенен Блан',
    'Пино Гриджио',
    'Харнат',
    'Гренаш',
    'Сираз',
    'Петит Вердо',
    'Цвайгельт',
    'Мускат',
    'Траминер',
    'Шираз',
    'Мулled Вино',
    'Мускатель',
    'Порто',
    'Хеннени',
    'Алиготе',
  ];
  
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      // Получаем уже выбранные значения
      final selectedValues = (filters['grape'] as List<String>?) ?? [];
      
      // Состояние для текста поиска
      final searchController = useTextEditingController();
      final filteredGrapes = useState<List<String>>(allGrapes);
      
      // Обработчик изменения текста поиска
      void onSearchTextChanged(String text) {
        if (text.isEmpty) {
          filteredGrapes.value = allGrapes;
        } else {
          filteredGrapes.value = allGrapes
              .where((grape) => grape.toLowerCase().contains(text.toLowerCase()))
              .toList();
        }
      }
      
      // Обновляем фильтрованный список при изменении начального значения
      useEffect(() {
        onSearchTextChanged(searchController.text);
        return null;
      }, []);
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Поиск по сорту',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              onSearchTextChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                for (String grape in filteredGrapes.value)
                  CheckboxListTile(
                    title: Text(grape),
                    value: selectedValues.contains(grape),
                    onChanged: (bool? value) {
                      final newSelectedValues = List<String>.from(selectedValues);
                      if (value == true) {
                        newSelectedValues.add(grape);
                      } else {
                        newSelectedValues.remove(grape);
                      }
                      selectedFilters.value['grape'] = newSelectedValues;
                      selectedFilters.value = Map.from(selectedFilters.value);
                    },
                  ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
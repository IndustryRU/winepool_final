import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

part 'temporary_winery_ids_provider.g.dart';

@riverpod
class TemporaryWineryIds extends _$TemporaryWineryIds {
  @override
  List<String> build() {
    // Инициализируем состояние текущими значениями из основного фильтра
    final filters = ref.watch(catalogFiltersProvider);
    return List.from(filters.wineryIds);
  }

  void add(String id) {
    if (id.isNotEmpty && !state.contains(id)) {
      state = [...state, id];
    }
  }

  void remove(String id) {
    if (id.isNotEmpty) {
      state = state.where((wineryId) => wineryId != id).toList();
    }
  }

  void clear() {
    state = [];
  }
}
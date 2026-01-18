import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

part 'temporary_selection_providers.g.dart';

/// Временное хранилище для ID виноделен, выбранных в фильтре
@riverpod
class TemporaryWineryIds extends _$TemporaryWineryIds {
  @override
  List<String> build() {
    final filters = ref.watch(catalogFiltersProvider);
    return filters.wineryIds;
  }

  void toggle(String id) {
    final currentIds = List<String>.from(state);
    if (currentIds.contains(id)) {
      currentIds.remove(id);
    } else {
      currentIds.add(id);
    }
    state = currentIds;
  }

  void reset() {
    final filters = ref.read(catalogFiltersProvider);
    state = filters.wineryIds;
  }

  void clear() {
    state = [];
  }
}

/// Временное хранилище для кодов стран, выбранных в фильтре
@riverpod
class TemporaryCountryCodes extends _$TemporaryCountryCodes {
  @override
  List<String> build() {
    final filters = ref.watch(catalogFiltersProvider);
    return filters.country;
  }

  void toggle(String code) {
    final currentCodes = List<String>.from(state);
    if (currentCodes.contains(code)) {
      currentCodes.remove(code);
    } else {
      currentCodes.add(code);
    }
    state = currentCodes;
  }

  void reset() {
    final filters = ref.read(catalogFiltersProvider);
    state = filters.country;
  }

  void clear() {
    state = [];
  }
}

/// Временное хранилище для ID сортов винограда, выбранных в фильтре
@riverpod
class TemporaryGrapeVarietyIds extends _$TemporaryGrapeVarietyIds {
  @override
  List<String> build() {
    return ref.watch(catalogFiltersProvider).grapeIds;
  }

  void toggle(String id) {
    final currentIds = List<String>.from(state);
    if (currentIds.contains(id)) {
      currentIds.remove(id);
    } else {
      currentIds.add(id);
    }
    state = currentIds;
  }

  void reset() {
    state = ref.read(catalogFiltersProvider).grapeIds;
  }

  void clear() {
    state = [];
  }
}

/// Временное хранилище для ID регионов, выбранных в фильтре
@riverpod
class TemporaryRegionIds extends _$TemporaryRegionIds {
  @override
  List<String> build() {
    return ref.watch(catalogFiltersProvider).region;
  }

 void toggle(String id) {
    final currentIds = List<String>.from(state);
    if (currentIds.contains(id)) {
      currentIds.remove(id);
    } else {
      currentIds.add(id);
    }
    state = currentIds;
  }

  void reset() {
    state = ref.read(catalogFiltersProvider).region;
  }

  void clear() {
    state = [];
  }
}

// Используем typedef для удобства
typedef PriceRange = (double?, double?);

/// Временное хранилище для диапазона цен, выбранного в фильтре
@riverpod
class TemporaryPriceRange extends _$TemporaryPriceRange {
  @override
  PriceRange build() {
    // Провайдер просто хранит состояние, не пытаясь его угадать.
    return (null, null);
  }

  void setMin(double? min) {
    state = (min, state.$2);
  }
  
  void setMax(double? max) {
    state = (state.$1, max);
  }

  void setRange(double min, double max) {
    state = (min, max);
  }
}

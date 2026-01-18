import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

part 'catalog_filters_provider.freezed.dart';
part 'catalog_filters_provider.g.dart';

@freezed
abstract class CatalogFiltersState with _$CatalogFiltersState {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CatalogFiltersState({
    @Default([]) List<String> wineryIds,
    @Default([]) List<String> region,
    @Default([]) List<String> grapeIds,
    @Default([]) List<WineColor> color,
    @Default([]) List<WineType> type,
    @Default([]) List<WineSugar> sugar,
    double? minPrice,
    double? maxPrice,
    @Default([]) List<String> country,
    double? minRating,
    @Default(1900) int? minYear,
    int? maxYear,
    @Default([]) List<String> bottleSizeIds,
    String? sortOption,
    @Default([]) List<int> vintages,  // Добавляем поле для фильтрации по винтажам
    @Default(false) bool showUnavailable, // Добавляем поле для показа недоступных
  }) = _CatalogFiltersState;

  // Добавляем factory конструктор fromJson
  factory CatalogFiltersState.fromJson(Map<String, dynamic> json) => _$CatalogFiltersStateFromJson(json);

  // Private constructor for freezed
  const CatalogFiltersState._();
  
  // Factory constructor for the initial state
  factory CatalogFiltersState.initial() => CatalogFiltersState(
        maxYear: DateTime.now().year,
      );
}

// Extension для предоставления геттера isAnyFilterActive
extension CatalogFiltersStateExtension on CatalogFiltersState {
  bool get isAnyFilterActive {
    final defaultState = CatalogFiltersState.initial();
    return wineryIds.isNotEmpty ||
        region.isNotEmpty ||
        grapeIds.isNotEmpty ||
        color.isNotEmpty ||
        type.isNotEmpty ||
        sugar.isNotEmpty ||
        minPrice != defaultState.minPrice ||
        maxPrice != defaultState.maxPrice ||
        country.isNotEmpty ||
        minRating != defaultState.minRating ||
        minYear != defaultState.minYear ||
        maxYear != defaultState.maxYear ||
        bottleSizeIds.isNotEmpty ||
        vintages.isNotEmpty; // Учитываем винтажи в проверке
  }
}

@riverpod
class CatalogFiltersNotifier extends _$CatalogFiltersNotifier {
  @override
  CatalogFiltersState build() {
    return CatalogFiltersState.initial();
  }

  void setWineries(List<String> ids) {
    state = state.copyWith(wineryIds: ids);
  }

  void setRegion(String? region) {
    state = state.copyWith(region: region == null ? [] : [region]);
  }
  
  void clearRegion() {
    state = state.copyWith(region: []);
  }

  void setGrape(String? grapeId) {
    state = state.copyWith(grapeIds: grapeId == null ? [] : [grapeId]);
  }

  void clearGrapes() {
    state = state.copyWith(grapeIds: []);
  }

  void setSortOption(String? option) {
    state = state.copyWith(sortOption: option);
  }

  void updateFilters(CatalogFiltersState newState) {
    state = newState;
  }
  
  void resetAllFilters() {
    state = CatalogFiltersState.initial();
  }

  // Методы сброса для каждого фильтра
  void resetRegionFilter() => state = state.copyWith(region: []);
  void resetColorFilter() => state = state.copyWith(color: []);
  void resetTypeFilter() => state = state.copyWith(type: []);
  void resetSugarFilter() => state = state.copyWith(sugar: []);
  void resetPriceFilter() => state = state.copyWith(minPrice: null, maxPrice: null);
  void resetCountryFilter() => state = state.copyWith(country: []);
 void resetRatingFilter() => state = state.copyWith(minRating: null);
  void resetYearFilter() => state = state.copyWith(minYear: 1900, maxYear: DateTime.now().year);
  void clearBottleSizes() => state = state.copyWith(bottleSizeIds: []);

  // Восстанавливаем недостающие методы, которые используются в других частях приложения
  void setPriceRange(double minPrice, double maxPrice) {
    state = state.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }

  void setShowUnavailable(bool showUnavailable) {
    state = state.copyWith(
      showUnavailable: showUnavailable,
    );
  }

  void resetShowUnavailableFilter() {
    state = state.copyWith(
      showUnavailable: false,
    );
  }

  void updateRegion(List<String> regions) {
    state = state.copyWith(
      region: regions,
    );
  }

  void toggleGrapeId(String grapeId) {
    final currentGrapes = state.grapeIds;
    if (currentGrapes.contains(grapeId)) {
      state = state.copyWith(grapeIds: List.from(currentGrapes)..remove(grapeId));
    } else {
      state = state.copyWith(grapeIds: List.from(currentGrapes)..add(grapeId));
    }
  }

  void clearWineries() {
    state = state.copyWith(wineryIds: []);
  }

  void toggleWineryId(String wineryId) {
    final currentWineries = state.wineryIds;
    if (currentWineries.contains(wineryId)) {
      state = state.copyWith(wineryIds: List.from(currentWineries)..remove(wineryId));
    } else {
      state = state.copyWith(wineryIds: List.from(currentWineries)..add(wineryId));
    }
  }

  // Методы для работы с фильтром по объему бутылки
  void toggleBottleSizeId(String id) {
    final currentIds = state.bottleSizeIds;
    if (currentIds.contains(id)) {
      state = state.copyWith(bottleSizeIds: List.from(currentIds)..remove(id));
    } else {
      state = state.copyWith(bottleSizeIds: List.from(currentIds)..add(id));
    }
  }

  // Новые методы для работы с винтажами
  void setVintages(List<int> vintages) {
    state = state.copyWith(
      vintages: vintages,
    );
  }

  void addVintage(int vintage) {
    final currentVintages = state.vintages;
    if (!currentVintages.contains(vintage)) {
      state = state.copyWith(vintages: List.from(currentVintages)..add(vintage));
    }
  }

  void removeVintage(int vintage) {
    final currentVintages = state.vintages;
    if (currentVintages.contains(vintage)) {
      state = state.copyWith(vintages: List.from(currentVintages)..remove(vintage));
    }
  }

  void toggleVintage(int vintage) {
    final currentVintages = state.vintages;
    if (currentVintages.contains(vintage)) {
      state = state.copyWith(vintages: List.from(currentVintages)..remove(vintage));
    } else {
      state = state.copyWith(vintages: List.from(currentVintages)..add(vintage));
    }
  }

  void resetVintageFilter() {
    state = state.copyWith(
      vintages: const [],
    );
  }

  void resetGrapeFilter() {
    state = state.copyWith(
      grapeIds: const [],
    );
  }

 void resetWineryFilter() {
    state = state.copyWith(
      wineryIds: const [],
    );
  }

  void resetBottleSizeFilter() {
    state = state.copyWith(
      bottleSizeIds: const [],
    );
  }
}

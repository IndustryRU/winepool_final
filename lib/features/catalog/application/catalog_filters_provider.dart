import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog_filters_provider.g.dart';
part 'catalog_filters_provider.freezed.dart';

@freezed
abstract class CatalogFiltersState with _$CatalogFiltersState {
  const factory CatalogFiltersState({
    @Default([]) List<String> color,
    @Default([]) List<String> type,
    @Default([]) List<String> sugar,
    double? minPrice,
    double? maxPrice,
    @Default([]) List<String> country,
    @Default([]) List<String> region,
    @Default([]) List<String> grapeIds,
    double? minRating,
    @Default(1900) int minYear,
    int? maxYear,
    @Default([]) List<String> bottleSizeIds, // Поле для фильтрации по объему бутылки
    @Default(false) bool showUnavailable,
    String? sortOption,
    @Default([]) List<int> vintages,  // Новое поле для фильтрации по винтажам
  }) = _CatalogFiltersState;
}

@riverpod
class CatalogFiltersNotifier extends _$CatalogFiltersNotifier {
  @override
  CatalogFiltersState build() {
    return const CatalogFiltersState();
  }

  void updateFilters(CatalogFiltersState newFilters) {
    state = newFilters;
  }

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

  void setAllFilters(CatalogFiltersState newFilters) {
    state = newFilters;
  }

  void resetFilters() {
    state = const CatalogFiltersState();
  }

  void resetPriceFilter() {
    state = state.copyWith(
      minPrice: null,
      maxPrice: null,
    );
  }

  void resetColorFilter() {
    state = state.copyWith(
      color: const [],
    );
  }

  void resetTypeFilter() {
    state = state.copyWith(
      type: const [],
    );
  }

  void resetSugarFilter() {
    state = state.copyWith(
      sugar: const [],
    );
  }

  void resetCountryFilter() {
    state = state.copyWith(
      country: const [],
    );
  }

  void resetRegionFilter() {
    state = state.copyWith(
      region: const [],
    );
  }

  void resetGrapeFilter() {
    state = state.copyWith(
      grapeIds: const [],
    );
  }

  void resetRatingFilter() {
    state = state.copyWith(
      minRating: null,
    );
  }

  void resetYearFilter() {
    state = state.copyWith(
      minYear: 1900,
      maxYear: null,
    );
  }

  void resetBottleSizeFilter() {
    state = state.copyWith(
      bottleSizeIds: const [],
    );
  }

  void resetShowUnavailableFilter() {
    state = state.copyWith(
      showUnavailable: false,
    );
  }

  void resetVintageFilter() {
    state = state.copyWith(
      vintages: const [],
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

  void clearGrapes() {
    state = state.copyWith(grapeIds: []);
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

  void clearBottleSizes() {
    state = state.copyWith(bottleSizeIds: []);
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
}

@riverpod
class RegionSearchText extends _$RegionSearchText {
  @override
  String build() {
    return '';
  }
}

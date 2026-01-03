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
    @Default([]) List<String> grape,
    double? minRating,
    @Default(1900) int minYear,
    int? maxYear,
    @Default([]) List<String> volume,
    @Default(false) bool showUnavailable,
    String? sortOption,
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
      grape: const [],
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

  void resetVolumeFilter() {
    state = state.copyWith(
      volume: const [],
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
}

@riverpod
class RegionSearchText extends _$RegionSearchText {
  @override
  String build() {
    return '';
  }
}

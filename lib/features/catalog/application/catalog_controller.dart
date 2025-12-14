import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_controller.g.dart';

@riverpod
class CatalogFilters extends _$CatalogFilters {
  @override
  Map<String, dynamic> build() {
    print('--- CATALOG FILTERS INITIALIZED ---');
    print('Initial state: {}');
    return {};
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    print('--- UPDATE FILTERS CALLED ---');
    print('New filters: $newFilters');
    state = newFilters;
    print('Updated state: $state');
  }

  void setPriceRange(double minPrice, double maxPrice) {
    print('--- SET PRICE RANGE CALLED ---');
    print('Min price: $minPrice, Max price: $maxPrice');
    state = {
      ...state,
      'min_price': minPrice,
      'max_price': maxPrice,
    };
    print('Updated state with price range: $state');
  }

  void setShowUnavailable(bool showUnavailable) {
    print('--- SET SHOW UNAVAILABLE CALLED ---');
    print('Show unavailable: $showUnavailable');
    state = {
      ...state,
      'show_unavailable': showUnavailable,
    };
    print('Updated state with show unavailable: $state');
  }

  void resetFilters() {
    print('--- RESET FILTERS CALLED ---');
    state = {};
    print('Reset state: $state');
  }
}

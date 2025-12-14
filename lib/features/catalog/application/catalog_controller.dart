import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers.dart';

part 'catalog_controller.g.dart';

@riverpod
class CatalogFilters extends _$CatalogFilters {
  @override
  Map<String, dynamic> build() {
    print('--- CATALOG FILTERS INITIALIZED ---');
    print('Initial state: {}');
    return {'min_year': 1900};
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

  void setAllFilters(Map<String, dynamic> newFilters) {
    print('--- SET ALL FILTERS CALLED ---');
    print('New filters: $newFilters');
    state = newFilters;
    print('Updated state with all filters: $state');
  }

  void resetFilters() {
    print('--- RESET FILTERS CALLED ---');
    state = {};
    print('Reset state: $state');
  }

  // Отдельные методы сброса для каждого фильтра
  void resetPriceFilter() {
    print('--- RESET PRICE FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('min_price');
    newState.remove('max_price');
    state = newState;
    print('Updated state after resetting price filter: $state');
  }

 void resetColorFilter() {
    print('--- RESET COLOR FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('color');
    state = newState;
    print('Updated state after resetting color filter: $state');
  }

 void resetTypeFilter() {
    print('--- RESET TYPE FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('type');
    state = newState;
    print('Updated state after resetting type filter: $state');
  }

  void resetSugarFilter() {
    print('--- RESET SUGAR FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('sugar');
    state = newState;
    print('Updated state after resetting sugar filter: $state');
  }

 void resetCountryFilter() {
    print('--- RESET COUNTRY FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('country');
    state = newState;
    print('Updated state after resetting country filter: $state');
  }

 void resetRegionFilter() {
    print('--- RESET REGION FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('region');
    state = newState;
    print('Updated state after resetting region filter: $state');
  }

  void resetGrapeFilter() {
    print('--- RESET GRAPE FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('grape');
    state = newState;
    print('Updated state after resetting grape filter: $state');
  }

 void resetRatingFilter() {
    print('--- RESET RATING FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('min_rating');
    state = newState;
    print('Updated state after resetting rating filter: $state');
  }

 void resetYearFilter() {
    print('--- RESET YEAR FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('min_year');
    newState.remove('max_year');
    state = newState;
    print('Updated state after resetting year filter: $state');
  }

  void resetVolumeFilter() {
    print('--- RESET VOLUME FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('volume');
    state = newState;
    print('Updated state after resetting volume filter: $state');
  }

 void resetShowUnavailableFilter() {
    print('--- RESET SHOW UNAVAILABLE FILTER CALLED ---');
    final newState = Map<String, dynamic>.from(state);
    newState.remove('show_unavailable');
    state = newState;
    print('Updated state after resetting show unavailable filter: $state');
  }
}

@riverpod
Future<Map<String, double>> priceRange(Ref ref) async {
  final currentFilters = ref.watch(catalogFiltersProvider);
  
  // Создаем копию фильтров, игнорируя 'showUnavailable'
  final filtersForPriceRange = Map<String, dynamic>.from(currentFilters);
  filtersForPriceRange.remove('show_unavailable');

  final supabaseClient = ref.watch(supabaseClientProvider);
  
  // Вызываем RPC-функцию с фильтрами без 'show_unavailable'
  final response = await supabaseClient.rpc('get_price_range', params: {
    'filters': filtersForPriceRange,
  });

  if (response.isEmpty) {
    return {'min_price': 0, 'max_price': 10000000};
  }
  
  final data = response[0];
  final minPrice = (data['min_price'] as num?)?.toDouble() ?? 0;
  final maxPrice = (data['max_price'] as num?)?.toDouble() ?? 10000000;
  
  return {'min_price': minPrice, 'max_price': maxPrice};
}

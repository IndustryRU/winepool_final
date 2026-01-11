import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

part 'temporary_rating_provider.g.dart';

@riverpod
class TemporaryRating extends _$TemporaryRating {
  @override
  double build() {
    return ref.watch(catalogFiltersProvider).minRating ?? 0.0;
  }

  void set(double rating) {
    state = rating;
  }
}
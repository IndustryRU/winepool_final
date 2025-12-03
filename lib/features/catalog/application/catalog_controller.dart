import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_controller.g.dart';

@riverpod
class CatalogFilters extends _$CatalogFilters {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void updateFilters(Map<String, dynamic> newFilters) {
    state = newFilters;
  }
}
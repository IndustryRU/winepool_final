// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CatalogFilters)
const catalogFiltersProvider = CatalogFiltersProvider._();

final class CatalogFiltersProvider
    extends $NotifierProvider<CatalogFilters, Map<String, dynamic>> {
  const CatalogFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$catalogFiltersHash();

  @$internal
  @override
  CatalogFilters create() => CatalogFilters();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$catalogFiltersHash() => r'ddb8c1ec5c1912df5b91950f41a49fa203153a3f';

abstract class _$CatalogFilters extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

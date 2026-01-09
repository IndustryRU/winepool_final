// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_filters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CatalogFiltersNotifier)
const catalogFiltersProvider = CatalogFiltersNotifierProvider._();

final class CatalogFiltersNotifierProvider
    extends $NotifierProvider<CatalogFiltersNotifier, CatalogFiltersState> {
  const CatalogFiltersNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$catalogFiltersNotifierHash();

  @$internal
  @override
  CatalogFiltersNotifier create() => CatalogFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogFiltersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogFiltersState>(value),
    );
  }
}

String _$catalogFiltersNotifierHash() =>
    r'2333ffa07ba01e9267aa066949d3caae19671cbd';

abstract class _$CatalogFiltersNotifier extends $Notifier<CatalogFiltersState> {
  CatalogFiltersState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CatalogFiltersState, CatalogFiltersState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CatalogFiltersState, CatalogFiltersState>,
              CatalogFiltersState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(RegionSearchText)
const regionSearchTextProvider = RegionSearchTextProvider._();

final class RegionSearchTextProvider
    extends $NotifierProvider<RegionSearchText, String> {
  const RegionSearchTextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionSearchTextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionSearchTextHash();

  @$internal
  @override
  RegionSearchText create() => RegionSearchText();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$regionSearchTextHash() => r'95d5311ced3110f01186203dc9ac39e3c6f891e7';

abstract class _$RegionSearchText extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

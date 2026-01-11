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
    r'59d7f45631fd23211ba9b9675ac19b09d4a0ff16';

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

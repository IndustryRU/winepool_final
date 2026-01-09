// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_filters_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogFiltersState _$CatalogFiltersStateFromJson(
  Map<String, dynamic> json,
) => _CatalogFiltersState(
  color:
      (json['color'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  type:
      (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sugar:
      (json['sugar'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  minPrice: (json['min_price'] as num?)?.toDouble(),
  maxPrice: (json['max_price'] as num?)?.toDouble(),
  country:
      (json['country'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  region:
      (json['region'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  grapeIds:
      (json['grape_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  wineryIds:
      (json['winery_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  minRating: (json['min_rating'] as num?)?.toDouble(),
  minYear: (json['min_year'] as num?)?.toInt() ?? 1900,
  maxYear: (json['max_year'] as num?)?.toInt(),
  bottleSizeIds:
      (json['bottle_size_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  showUnavailable: json['show_unavailable'] as bool? ?? false,
  sortOption: json['sort_option'] as String?,
  vintages:
      (json['vintages'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
);

Map<String, dynamic> _$CatalogFiltersStateToJson(
  _CatalogFiltersState instance,
) => <String, dynamic>{
  'color': instance.color,
  'type': instance.type,
  'sugar': instance.sugar,
  'min_price': instance.minPrice,
  'max_price': instance.maxPrice,
  'country': instance.country,
  'region': instance.region,
  'grape_ids': instance.grapeIds,
  'winery_ids': instance.wineryIds,
  'min_rating': instance.minRating,
  'min_year': instance.minYear,
  'max_year': instance.maxYear,
  'bottle_size_ids': instance.bottleSizeIds,
  'show_unavailable': instance.showUnavailable,
  'sort_option': instance.sortOption,
  'vintages': instance.vintages,
};

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
    r'59639589c43995fb7fee5eb6a1749d534aabdbc2';

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

@ProviderFor(TemporaryFiltersNotifier)
const temporaryFiltersProvider = TemporaryFiltersNotifierProvider._();

final class TemporaryFiltersNotifierProvider
    extends $NotifierProvider<TemporaryFiltersNotifier, CatalogFiltersState> {
  const TemporaryFiltersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryFiltersNotifierHash();

  @$internal
  @override
  TemporaryFiltersNotifier create() => TemporaryFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogFiltersState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogFiltersState>(value),
    );
  }
}

String _$temporaryFiltersNotifierHash() =>
    r'94b3bccd64426b3eb3d9cee1d3579d6b5681318e';

abstract class _$TemporaryFiltersNotifier
    extends $Notifier<CatalogFiltersState> {
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

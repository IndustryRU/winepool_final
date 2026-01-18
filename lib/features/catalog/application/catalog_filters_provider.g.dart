// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_filters_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogFiltersState _$CatalogFiltersStateFromJson(
  Map<String, dynamic> json,
) => _CatalogFiltersState(
  wineryIds:
      (json['winery_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  region:
      (json['region'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  grapeIds:
      (json['grape_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  color:
      (json['color'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$WineColorEnumMap, e))
          .toList() ??
      const [],
  type:
      (json['type'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$WineTypeEnumMap, e))
          .toList() ??
      const [],
  sugar:
      (json['sugar'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$WineSugarEnumMap, e))
          .toList() ??
      const [],
  minPrice: (json['min_price'] as num?)?.toDouble(),
  maxPrice: (json['max_price'] as num?)?.toDouble(),
  country:
      (json['country'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  minRating: (json['min_rating'] as num?)?.toDouble(),
  minYear: (json['min_year'] as num?)?.toInt() ?? 1900,
  maxYear: (json['max_year'] as num?)?.toInt(),
  bottleSizeIds:
      (json['bottle_size_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  sortOption: json['sort_option'] as String?,
  vintages:
      (json['vintages'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const [],
  showUnavailable: json['show_unavailable'] as bool? ?? false,
);

Map<String, dynamic> _$CatalogFiltersStateToJson(
  _CatalogFiltersState instance,
) => <String, dynamic>{
  'winery_ids': instance.wineryIds,
  'region': instance.region,
  'grape_ids': instance.grapeIds,
  'color': instance.color.map((e) => _$WineColorEnumMap[e]!).toList(),
  'type': instance.type.map((e) => _$WineTypeEnumMap[e]!).toList(),
  'sugar': instance.sugar.map((e) => _$WineSugarEnumMap[e]!).toList(),
  'min_price': instance.minPrice,
  'max_price': instance.maxPrice,
  'country': instance.country,
  'min_rating': instance.minRating,
  'min_year': instance.minYear,
  'max_year': instance.maxYear,
  'bottle_size_ids': instance.bottleSizeIds,
  'sort_option': instance.sortOption,
  'vintages': instance.vintages,
  'show_unavailable': instance.showUnavailable,
};

const _$WineColorEnumMap = {
  WineColor.red: 'red',
  WineColor.white: 'white',
  WineColor.rose: 'rosé',
  WineColor.orange: 'orange',
  WineColor.unknown: 'unknown',
};

const _$WineTypeEnumMap = {
  WineType.still: 'still',
  WineType.sparkling: 'sparkling',
  WineType.fortified: 'fortified',
  WineType.unknown: 'unknown',
};

const _$WineSugarEnumMap = {
  WineSugar.dry: 'dry',
  WineSugar.semiDry: 'semi_dry',
  WineSugar.semiSweet: 'semi_sweet',
  WineSugar.sweet: 'sweet',
  WineSugar.unknown: 'unknown',
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

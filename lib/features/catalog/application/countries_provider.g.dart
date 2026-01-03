// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countriesList)
const countriesListProvider = CountriesListProvider._();

final class CountriesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Country>>,
          List<Country>,
          FutureOr<List<Country>>
        >
    with $FutureModifier<List<Country>>, $FutureProvider<List<Country>> {
  const CountriesListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesListHash();

  @$internal
  @override
  $FutureProviderElement<List<Country>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Country>> create(Ref ref) {
    return countriesList(ref);
  }
}

String _$countriesListHash() => r'4db56da1c9be01620404c0c907821b928d62dfff';

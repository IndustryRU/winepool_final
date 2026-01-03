// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_selection_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedCountries)
const selectedCountriesProvider = SelectedCountriesProvider._();

final class SelectedCountriesProvider
    extends $NotifierProvider<SelectedCountries, List<String>> {
  const SelectedCountriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCountriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCountriesHash();

  @$internal
  @override
  SelectedCountries create() => SelectedCountries();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$selectedCountriesHash() => r'6be69c7694ef96258a48f2284b0ce3edf1d3a4d5';

abstract class _$SelectedCountries extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

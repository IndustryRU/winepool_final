// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_selection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Временное хранилище для ID виноделен, выбранных в фильтре

@ProviderFor(TemporaryWineryIds)
const temporaryWineryIdsProvider = TemporaryWineryIdsProvider._();

/// Временное хранилище для ID виноделен, выбранных в фильтре
final class TemporaryWineryIdsProvider
    extends $NotifierProvider<TemporaryWineryIds, List<String>> {
  /// Временное хранилище для ID виноделен, выбранных в фильтре
  const TemporaryWineryIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryWineryIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryWineryIdsHash();

  @$internal
  @override
  TemporaryWineryIds create() => TemporaryWineryIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$temporaryWineryIdsHash() =>
    r'2a322771751e95c02d0e76913db15983f999fc05';

/// Временное хранилище для ID виноделен, выбранных в фильтре

abstract class _$TemporaryWineryIds extends $Notifier<List<String>> {
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

/// Временное хранилище для кодов стран, выбранных в фильтре

@ProviderFor(TemporaryCountryCodes)
const temporaryCountryCodesProvider = TemporaryCountryCodesProvider._();

/// Временное хранилище для кодов стран, выбранных в фильтре
final class TemporaryCountryCodesProvider
    extends $NotifierProvider<TemporaryCountryCodes, List<String>> {
  /// Временное хранилище для кодов стран, выбранных в фильтре
  const TemporaryCountryCodesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryCountryCodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryCountryCodesHash();

  @$internal
  @override
  TemporaryCountryCodes create() => TemporaryCountryCodes();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$temporaryCountryCodesHash() =>
    r'2f106661455ca5cabc167cfc8ed009421b01349d';

/// Временное хранилище для кодов стран, выбранных в фильтре

abstract class _$TemporaryCountryCodes extends $Notifier<List<String>> {
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

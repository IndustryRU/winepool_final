// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wines_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeScreenAggregate)
const homeScreenAggregateProvider = HomeScreenAggregateProvider._();

final class HomeScreenAggregateProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeScreenData>,
          HomeScreenData,
          FutureOr<HomeScreenData>
        >
    with $FutureModifier<HomeScreenData>, $FutureProvider<HomeScreenData> {
  const HomeScreenAggregateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeScreenAggregateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeScreenAggregateHash();

  @$internal
  @override
  $FutureProviderElement<HomeScreenData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeScreenData> create(Ref ref) {
    return homeScreenAggregate(ref);
  }
}

String _$homeScreenAggregateHash() =>
    r'bcec0b650c80eed9aa36139be848f3b3918c2fa7';

@ProviderFor(winesController)
const winesControllerProvider = WinesControllerProvider._();

final class WinesControllerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const WinesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'winesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$winesControllerHash();

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    return winesController(ref);
  }
}

String _$winesControllerHash() => r'4522757903744a05620d96c51ad394dd86748b4d';

@ProviderFor(winesByWinery)
const winesByWineryProvider = WinesByWineryFamily._();

final class WinesByWineryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const WinesByWineryProvider._({
    required WinesByWineryFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'winesByWineryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$winesByWineryHash();

  @override
  String toString() {
    return r'winesByWineryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    final argument = this.argument as String?;
    return winesByWinery(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WinesByWineryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$winesByWineryHash() => r'6849300720aade90bafc7bd2ba66770af0e9aa01';

final class WinesByWineryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Wine>>, String?> {
  const WinesByWineryFamily._()
    : super(
        retry: null,
        name: r'winesByWineryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WinesByWineryProvider call(String? wineryId) =>
      WinesByWineryProvider._(argument: wineryId, from: this);

  @override
  String toString() => r'winesByWineryProvider';
}

@ProviderFor(allWines)
const allWinesProvider = AllWinesProvider._();

final class AllWinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const AllWinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allWinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allWinesHash();

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    return allWines(ref);
  }
}

String _$allWinesHash() => r'23bdf552b9591627b860a3e40258cb223b992e4d';

@ProviderFor(popularWines)
const popularWinesProvider = PopularWinesProvider._();

final class PopularWinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const PopularWinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'popularWinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$popularWinesHash();

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    return popularWines(ref);
  }
}

String _$popularWinesHash() => r'83f67c1439551b6fd54dc5642dc75deb219976dd';

@ProviderFor(newWines)
const newWinesProvider = NewWinesProvider._();

final class NewWinesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const NewWinesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newWinesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newWinesHash();

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    return newWines(ref);
  }
}

String _$newWinesHash() => r'dca3b106462081e296e9b632d15cf6b2ad2ebd35';

@ProviderFor(winesWithActiveFilters)
const winesWithActiveFiltersProvider = WinesWithActiveFiltersProvider._();

final class WinesWithActiveFiltersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const WinesWithActiveFiltersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'winesWithActiveFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$winesWithActiveFiltersHash();

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    return winesWithActiveFilters(ref);
  }
}

String _$winesWithActiveFiltersHash() =>
    r'5607a144dac27e4b9a4f8a7a5142b0445047bba9';

@ProviderFor(WineMutation)
const wineMutationProvider = WineMutationProvider._();

final class WineMutationProvider
    extends $NotifierProvider<WineMutation, AsyncValue<void>> {
  const WineMutationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wineMutationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wineMutationHash();

  @$internal
  @override
  WineMutation create() => WineMutation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$wineMutationHash() => r'524dbd636f86214919f7c1588913932dc5e7fb93';

abstract class _$WineMutation extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wines_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$winesControllerHash() => r'a33135cc3b6063fcfc764554e05cbb8eea32ca81';

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

String _$winesByWineryHash() => r'02997cda6cc513f913de2a4729b97d0f84f2421f';

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

String _$allWinesHash() => r'9b2e4463fc739dd8a5460234ec00f04cc03e6e63';

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

String _$popularWinesHash() => r'8eaddc2ed89cbe4825d77b28f97996e88cfe78a5';

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

String _$newWinesHash() => r'813127258e35dff47ed5404da62adfb601924740';

@ProviderFor(winesWithFilters)
const winesWithFiltersProvider = WinesWithFiltersFamily._();

final class WinesWithFiltersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Wine>>,
          List<Wine>,
          FutureOr<List<Wine>>
        >
    with $FutureModifier<List<Wine>>, $FutureProvider<List<Wine>> {
  const WinesWithFiltersProvider._({
    required WinesWithFiltersFamily super.from,
    required Map<String, dynamic> super.argument,
  }) : super(
         retry: null,
         name: r'winesWithFiltersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$winesWithFiltersHash();

  @override
  String toString() {
    return r'winesWithFiltersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Wine>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Wine>> create(Ref ref) {
    final argument = this.argument as Map<String, dynamic>;
    return winesWithFilters(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WinesWithFiltersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$winesWithFiltersHash() => r'30447becc7e1edc73ae58c89a295f03a974815e8';

final class WinesWithFiltersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Wine>>, Map<String, dynamic>> {
  const WinesWithFiltersFamily._()
    : super(
        retry: null,
        name: r'winesWithFiltersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WinesWithFiltersProvider call(Map<String, dynamic> filters) =>
      WinesWithFiltersProvider._(argument: filters, from: this);

  @override
  String toString() => r'winesWithFiltersProvider';
}

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
    r'6dee188028d00fb37106927c2915345bea594dce';

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

String _$wineMutationHash() => r'd383c459a66c9f516e3a284b7f84f419d9cd49e3';

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

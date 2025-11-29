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
    required String super.argument,
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
    final argument = this.argument as String;
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

String _$winesByWineryHash() => r'6863e1005f4543f289ba99d361b17ed00b167122';

final class WinesByWineryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Wine>>, String> {
  const WinesByWineryFamily._()
    : super(
        retry: null,
        name: r'winesByWineryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WinesByWineryProvider call(String wineryId) =>
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

String _$wineMutationHash() => r'8438b4c0293abd9efa399fb58873d9d2182a419a';

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

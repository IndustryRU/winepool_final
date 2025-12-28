// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OffersController)
const offersControllerProvider = OffersControllerProvider._();

final class OffersControllerProvider
    extends $AsyncNotifierProvider<OffersController, List<Offer>> {
  const OffersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offersControllerHash();

  @$internal
  @override
  OffersController create() => OffersController();
}

String _$offersControllerHash() => r'1f8e52499d11614e2eff8994fa4ceb3f308507b3';

abstract class _$OffersController extends $AsyncNotifier<List<Offer>> {
  FutureOr<List<Offer>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Offer>>, List<Offer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Offer>>, List<Offer>>,
              AsyncValue<List<Offer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(myOffersController)
const myOffersControllerProvider = MyOffersControllerProvider._();

final class MyOffersControllerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          FutureOr<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $FutureProvider<List<Offer>> {
  const MyOffersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myOffersControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myOffersControllerHash();

  @$internal
  @override
  $FutureProviderElement<List<Offer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Offer>> create(Ref ref) {
    return myOffersController(ref);
  }
}

String _$myOffersControllerHash() =>
    r'c566aa45cf406f2fc42f345613e1ee39844489f2';

@ProviderFor(winePriceRangeProvider)
const winePriceRangeProviderProvider = WinePriceRangeProviderFamily._();

final class WinePriceRangeProviderProvider
    extends
        $FunctionalProvider<
          AsyncValue<(double, double)?>,
          (double, double)?,
          FutureOr<(double, double)?>
        >
    with
        $FutureModifier<(double, double)?>,
        $FutureProvider<(double, double)?> {
  const WinePriceRangeProviderProvider._({
    required WinePriceRangeProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'winePriceRangeProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$winePriceRangeProviderHash();

  @override
  String toString() {
    return r'winePriceRangeProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<(double, double)?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<(double, double)?> create(Ref ref) {
    final argument = this.argument as String;
    return winePriceRangeProvider(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WinePriceRangeProviderProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$winePriceRangeProviderHash() =>
    r'c1654141e17172888a6a92acec0c30e1f3e3a15e';

final class WinePriceRangeProviderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<(double, double)?>, String> {
  const WinePriceRangeProviderFamily._()
    : super(
        retry: null,
        name: r'winePriceRangeProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WinePriceRangeProviderProvider call(String wineId) =>
      WinePriceRangeProviderProvider._(argument: wineId, from: this);

  @override
  String toString() => r'winePriceRangeProviderProvider';
}

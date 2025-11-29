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

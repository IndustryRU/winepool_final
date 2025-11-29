// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_offers_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AllOffersController)
const allOffersControllerProvider = AllOffersControllerProvider._();

final class AllOffersControllerProvider
    extends $AsyncNotifierProvider<AllOffersController, List<Offer>> {
  const AllOffersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allOffersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allOffersControllerHash();

  @$internal
  @override
  AllOffersController create() => AllOffersController();
}

String _$allOffersControllerHash() =>
    r'a4771fa50d7e2ebb559cfb4f1c818a26ecf6e83e';

abstract class _$AllOffersController extends $AsyncNotifier<List<Offer>> {
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

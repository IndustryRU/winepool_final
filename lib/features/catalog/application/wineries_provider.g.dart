// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wineries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allWineries)
const allWineriesProvider = AllWineriesProvider._();

final class AllWineriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Winery>>,
          List<Winery>,
          FutureOr<List<Winery>>
        >
    with $FutureModifier<List<Winery>>, $FutureProvider<List<Winery>> {
  const AllWineriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allWineriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allWineriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Winery>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Winery>> create(Ref ref) {
    return allWineries(ref);
  }
}

String _$allWineriesHash() => r'55904ec97e6cb347f2bee0ff0c3d2c37fb0c03d6';

@ProviderFor(availableColors)
const availableColorsProvider = AvailableColorsProvider._();

final class AvailableColorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WineColor>>,
          List<WineColor>,
          FutureOr<List<WineColor>>
        >
    with $FutureModifier<List<WineColor>>, $FutureProvider<List<WineColor>> {
  const AvailableColorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableColorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableColorsHash();

  @$internal
  @override
  $FutureProviderElement<List<WineColor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WineColor>> create(Ref ref) {
    return availableColors(ref);
  }
}

String _$availableColorsHash() => r'227b705d864d352553a939d67e15fb6068307384';

@ProviderFor(partnerWineries)
const partnerWineriesProvider = PartnerWineriesProvider._();

final class PartnerWineriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Winery>>,
          List<Winery>,
          FutureOr<List<Winery>>
        >
    with $FutureModifier<List<Winery>>, $FutureProvider<List<Winery>> {
  const PartnerWineriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'partnerWineriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$partnerWineriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Winery>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Winery>> create(Ref ref) {
    return partnerWineries(ref);
  }
}

String _$partnerWineriesHash() => r'b2c5bb262870aef8dd44149ed153e212ce15b826';

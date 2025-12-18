// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cellar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CellarController)
const cellarControllerProvider = CellarControllerProvider._();

final class CellarControllerProvider
    extends $AsyncNotifierProvider<CellarController, CellarData> {
  const CellarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellarControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellarControllerHash();

  @$internal
  @override
  CellarController create() => CellarController();
}

String _$cellarControllerHash() => r'310eba4f3c0a5d9743e4caf732ab616d92aac6a1';

abstract class _$CellarController extends $AsyncNotifier<CellarData> {
  FutureOr<CellarData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CellarData>, CellarData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CellarData>, CellarData>,
              AsyncValue<CellarData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(cellarTastings)
const cellarTastingsProvider = CellarTastingsProvider._();

final class CellarTastingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserTasting>>,
          List<UserTasting>,
          FutureOr<List<UserTasting>>
        >
    with
        $FutureModifier<List<UserTasting>>,
        $FutureProvider<List<UserTasting>> {
  const CellarTastingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellarTastingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellarTastingsHash();

  @$internal
  @override
  $FutureProviderElement<List<UserTasting>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserTasting>> create(Ref ref) {
    return cellarTastings(ref);
  }
}

String _$cellarTastingsHash() => r'ce26b7b6abebed9426a027d373585d639a1f7128';

@ProviderFor(cellarStorage)
const cellarStorageProvider = CellarStorageProvider._();

final class CellarStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UserStorageItem>>,
          List<UserStorageItem>,
          FutureOr<List<UserStorageItem>>
        >
    with
        $FutureModifier<List<UserStorageItem>>,
        $FutureProvider<List<UserStorageItem>> {
  const CellarStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cellarStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cellarStorageHash();

  @$internal
  @override
  $FutureProviderElement<List<UserStorageItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserStorageItem>> create(Ref ref) {
    return cellarStorage(ref);
  }
}

String _$cellarStorageHash() => r'9c029ba1fe46135dfd29e2a05c64705795e57479';

@ProviderFor(analytics)
const analyticsProvider = AnalyticsProvider._();

final class AnalyticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalyticsData>,
          AnalyticsData,
          FutureOr<AnalyticsData>
        >
    with $FutureModifier<AnalyticsData>, $FutureProvider<AnalyticsData> {
  const AnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsHash();

  @$internal
  @override
  $FutureProviderElement<AnalyticsData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalyticsData> create(Ref ref) {
    return analytics(ref);
  }
}

String _$analyticsHash() => r'22602c66bda5f9e2fd3d912e8db8cfd2902ecec7';

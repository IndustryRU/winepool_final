// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wineries_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WineriesController)
const wineriesControllerProvider = WineriesControllerProvider._();

final class WineriesControllerProvider
    extends $AsyncNotifierProvider<WineriesController, List<Winery>> {
  const WineriesControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wineriesControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wineriesControllerHash();

  @$internal
  @override
  WineriesController create() => WineriesController();
}

String _$wineriesControllerHash() =>
    r'7d96da479cf5c828140dfe48b0d303ae9ea5c38d';

abstract class _$WineriesController extends $AsyncNotifier<List<Winery>> {
  FutureOr<List<Winery>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Winery>>, List<Winery>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Winery>>, List<Winery>>,
              AsyncValue<List<Winery>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

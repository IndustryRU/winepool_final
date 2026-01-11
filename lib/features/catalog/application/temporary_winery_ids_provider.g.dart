// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_winery_ids_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemporaryWineryIds)
const temporaryWineryIdsProvider = TemporaryWineryIdsProvider._();

final class TemporaryWineryIdsProvider
    extends $NotifierProvider<TemporaryWineryIds, List<String>> {
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
    r'f2a68a06a6c83adb3ba60aa0ed81a19788377e5d';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_selection_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedRegions)
const selectedRegionsProvider = SelectedRegionsProvider._();

final class SelectedRegionsProvider
    extends $NotifierProvider<SelectedRegions, Set<String>> {
  const SelectedRegionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedRegionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedRegionsHash();

  @$internal
  @override
  SelectedRegions create() => SelectedRegions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$selectedRegionsHash() => r'78a99eb161aa1c502dd6fc6122f885f2e0302f79';

abstract class _$SelectedRegions extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

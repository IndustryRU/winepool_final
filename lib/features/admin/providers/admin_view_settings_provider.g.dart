// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_view_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminViewSettings)
const adminViewSettingsProvider = AdminViewSettingsProvider._();

final class AdminViewSettingsProvider
    extends $NotifierProvider<AdminViewSettings, bool> {
  const AdminViewSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminViewSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminViewSettingsHash();

  @$internal
  @override
  AdminViewSettings create() => AdminViewSettings();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adminViewSettingsHash() => r'f859d9bb773ceed80f14c1e39e03768a5f4d44e1';

abstract class _$AdminViewSettings extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

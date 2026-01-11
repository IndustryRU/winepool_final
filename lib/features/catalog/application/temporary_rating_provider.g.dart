// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temporary_rating_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TemporaryRating)
const temporaryRatingProvider = TemporaryRatingProvider._();

final class TemporaryRatingProvider
    extends $NotifierProvider<TemporaryRating, double> {
  const TemporaryRatingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temporaryRatingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temporaryRatingHash();

  @$internal
  @override
  TemporaryRating create() => TemporaryRating();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$temporaryRatingHash() => r'c05c4722567e526e34458aaab03135512938e681';

abstract class _$TemporaryRating extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vintage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(availableVintages)
const availableVintagesProvider = AvailableVintagesProvider._();

final class AvailableVintagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<int>>,
          List<int>,
          FutureOr<List<int>>
        >
    with $FutureModifier<List<int>>, $FutureProvider<List<int>> {
  const AvailableVintagesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'availableVintagesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$availableVintagesHash();

  @$internal
  @override
  $FutureProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>> create(Ref ref) {
    return availableVintages(ref);
  }
}

String _$availableVintagesHash() => r'a67306b7e5658976c57cf13e2986f5056c4a3c1e';

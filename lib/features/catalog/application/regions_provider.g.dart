// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(regionsList)
const regionsListProvider = RegionsListFamily._();

final class RegionsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Region>>,
          List<Region>,
          FutureOr<List<Region>>
        >
    with $FutureModifier<List<Region>>, $FutureProvider<List<Region>> {
  const RegionsListProvider._({
    required RegionsListFamily super.from,
    required List<String> super.argument,
  }) : super(
         retry: null,
         name: r'regionsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$regionsListHash();

  @override
  String toString() {
    return r'regionsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Region>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Region>> create(Ref ref) {
    final argument = this.argument as List<String>;
    return regionsList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RegionsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$regionsListHash() => r'27dff2d51bfd171d0145308fd2836e5270ea5ff9';

final class RegionsListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Region>>, List<String>> {
  const RegionsListFamily._()
    : super(
        retry: null,
        name: r'regionsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RegionsListProvider call(List<String> countryCodes) =>
      RegionsListProvider._(argument: countryCodes, from: this);

  @override
  String toString() => r'regionsListProvider';
}

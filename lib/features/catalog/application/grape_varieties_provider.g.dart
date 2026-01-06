// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grape_varieties_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allGrapeVarieties)
const allGrapeVarietiesProvider = AllGrapeVarietiesProvider._();

final class AllGrapeVarietiesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GrapeVariety>>,
          List<GrapeVariety>,
          FutureOr<List<GrapeVariety>>
        >
    with
        $FutureModifier<List<GrapeVariety>>,
        $FutureProvider<List<GrapeVariety>> {
  const AllGrapeVarietiesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allGrapeVarietiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allGrapeVarietiesHash();

  @$internal
  @override
  $FutureProviderElement<List<GrapeVariety>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GrapeVariety>> create(Ref ref) {
    return allGrapeVarieties(ref);
  }
}

String _$allGrapeVarietiesHash() => r'c9cef1ba83c39e15d0945db076d7a311dce1aba2';

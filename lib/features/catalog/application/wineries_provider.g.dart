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

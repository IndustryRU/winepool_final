import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../wines/data/grape_variety_repository.dart';
import '../../wines/domain/grape_variety.dart';

part 'grape_varieties_provider.g.dart';

@riverpod
Future<List<GrapeVariety>> allGrapeVarieties(Ref ref) {
 return ref.watch(grapeVarietyRepositoryProvider).fetchAllGrapeVarieties();
}
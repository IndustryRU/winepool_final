import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/offers/data/offers_repository.dart';
import 'package:winepool_final/features/offers/domain/bottle_size.dart';

final allBottleSizesProvider = FutureProvider<List<BottleSize>>((ref) async {
  final repo = ref.watch(offersRepositoryProvider);
  return await repo.getAllBottleSizes();
});
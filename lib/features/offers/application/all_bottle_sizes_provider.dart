import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/offers/data/offers_repository.dart';
import 'package:winepool_final/features/offers/domain/bottle_size.dart';
import 'package:winepool_final/core/providers.dart';

final availableBottleSizesProvider = FutureProvider<List<BottleSize>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_bottle_sizes');
  final bottleSizes = (data as List).map((json) => BottleSize.fromJson(json)).toList();
  bottleSizes.sort((a, b) => (a.sizeMl ?? 0).compareTo(b.sizeMl ?? 0));
 return bottleSizes;
});
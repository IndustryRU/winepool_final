import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

part 'wineries_provider.g.dart';

@riverpod
Future<List<Winery>> allWineries(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_wineries');
  return (data as List).map((json) => Winery.fromJson(json)).toList();
}
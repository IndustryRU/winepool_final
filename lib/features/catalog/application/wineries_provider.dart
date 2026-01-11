import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/data/wineries_repository.dart';

part 'wineries_provider.g.dart';

@riverpod
Future<List<Winery>> allWineries(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_wineries');
  return (data as List).map((json) => Winery.fromJson(json)).toList();
}

@riverpod
Future<List<WineColor>> availableColors(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_colors');
  // Supabase возвращает список строк, нам нужно их преобразовать в enum
  return (data as List).map((s) => WineColor.values.byName(s)).toList();
}

@riverpod
Future<List<Winery>> partnerWineries(Ref ref) async {
  // Используем репозиторий, а не прямой вызов rpc
  final wineriesRepository = ref.watch(wineriesRepositoryProvider);
  return wineriesRepository.getPartnerWineries();
}
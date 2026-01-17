import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/wines/domain/region.dart';
import 'package:winepool_final/core/providers.dart';

final regionsRepositoryProvider = Provider<RegionsRepository>((ref) {
  return RegionsRepository(ref.read(supabaseClientProvider));
});

class RegionsRepository {
  final SupabaseClient _supabaseClient;

  RegionsRepository(this._supabaseClient);

  Future<List<Region>> fetchAllRegions() async {
    final response = await _supabaseClient.from('regions').select('*, countries(*)').order('name', ascending: true);
    final List<dynamic> data = response as List<dynamic>;
    return data.map((e) => Region.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Region>> fetchPopularRegions() async {
    final response = await _supabaseClient.from('regions').select('*, countries(*)').eq('is_popular', true).order('name', ascending: true);
    final List<dynamic> data = response as List<dynamic>;
    return data.map((e) => Region.fromJson(e as Map<String, dynamic>)).toList();
  }
}
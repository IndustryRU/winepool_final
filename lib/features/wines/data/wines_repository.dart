import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/wine.dart';
import '../../../core/providers.dart';

final winesRepositoryProvider = Provider<WinesRepository>((ref) {
  return WinesRepository(ref.read(supabaseClientProvider));
});

class WinesRepository {
  final SupabaseClient _supabaseClient;

  WinesRepository(this._supabaseClient);

  Future<List<Wine>> fetchAllWines() async {
    print('--- FETCHING ALL WINES FROM SUPABASE ---');
    final response = await _supabaseClient
        .from('wines')
        .select('id, name, winery_id, grape_variety, description, image_url, created_at')
        .order('created_at', ascending: false);
    print('--- SUPABASE RESPONSE ---');
    print(response);
    print('--- END OF SUPABASE RESPONSE ---');

    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> fetchAllWinesNoFilter() async {
    final response = await _supabaseClient
        .from('wines')
        .select();
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<Wine> fetchWine(String wineId) async {
    final response = await _supabaseClient
        .from('wines')
        .select('id, name, winery_id, grape_variety, description, image_url, created_at')
        .eq('id', wineId)
        .single();

    return Wine.fromJson(response);
  }

  Future<List<Wine>> fetchWinesByWinery(String wineryId) async {
    final response = await _supabaseClient
        .from('wines')
        .select()
        .eq('winery_id', wineryId);
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<void> addWine(Wine wine) async {
    await _supabaseClient.from('wines').insert(wine.toJson());
  }

  Future<void> updateWine(Wine wine) async {
    await _supabaseClient.from('wines').update(wine.toJson()).match({'id': wine.id!});
  }

  Future<void> deleteWine(String wineId) async {
    await _supabaseClient.from('wines').delete().match({'id': wineId});
  }
}
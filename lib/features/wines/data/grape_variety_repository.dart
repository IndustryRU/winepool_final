import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/grape_variety.dart';
import '../../../core/providers.dart';

final grapeVarietyRepositoryProvider = Provider<GrapeVarietyRepository>((ref) {
  return GrapeVarietyRepository(ref.read(supabaseClientProvider));
});

class GrapeVarietyRepository {
  final SupabaseClient _supabaseClient;

  GrapeVarietyRepository(this._supabaseClient);

  Future<List<GrapeVariety>> fetchAllGrapeVarieties() async {
    final response = await _supabaseClient
        .from('grape_varieties')
        .select('*')
        .order('name', ascending: true);
    return response.map((json) => GrapeVariety.fromJson(json)).toList();
  }

  Future<GrapeVariety> fetchGrapeVariety(String id) async {
    final response = await _supabaseClient
        .from('grape_varieties')
        .select('*')
        .eq('id', id)
        .single();
    return GrapeVariety.fromJson(response);
  }

  Future<GrapeVariety> addGrapeVariety(GrapeVariety grapeVariety) async {
    final response = await _supabaseClient
        .from('grape_varieties')
        .insert(grapeVariety.toJson())
        .select()
        .single();
    return GrapeVariety.fromJson(response);
  }

  Future<void> updateGrapeVariety(GrapeVariety grapeVariety) async {
    if (grapeVariety.id == null) {
      throw Exception('Cannot update grape variety without ID');
    }
    await _supabaseClient
        .from('grape_varieties')
        .update(grapeVariety.toJson())
        .match({'id': grapeVariety.id!});
  }

  Future<void> deleteGrapeVariety(String id) async {
    await _supabaseClient
        .from('grape_varieties')
        .delete()
        .match({'id': id});
  }

  Future<List<GrapeVariety>> searchGrapeVarieties(String query) async {
    final response = await _supabaseClient
        .from('grape_varieties')
        .select('*')
        .ilike('name', '%$query%')
        .order('name', ascending: true);
    return response.map((json) => GrapeVariety.fromJson(json)).toList();
  }
}
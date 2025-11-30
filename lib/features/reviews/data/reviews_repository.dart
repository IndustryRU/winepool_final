import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/review.dart';

class ReviewsRepository {
  final SupabaseClient _supabaseClient;

  ReviewsRepository(this._supabaseClient);

  Future<List<Review>> fetchReviews(String wineId) async {
    final response = await _supabaseClient
        .from('reviews')
        .select()
        .eq('wine_id', wineId)
        .order('created_at', ascending: false);

    return response.map((json) => Review.fromJson(json)).toList();
  }

 Future<void> addReview(Review review) async {
    await _supabaseClient.from('reviews').insert(review.toJson());
  }
}
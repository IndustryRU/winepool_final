import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/supabase_provider.dart';
import '../domain/review.dart';
import '../data/reviews_repository.dart';

final reviewsControllerProvider = FutureProvider.family<List<Review>, String>((ref, wineId) async {
  final supabaseClient = ref.watch(supabaseClientProvider);
  final repository = ReviewsRepository(supabaseClient);
  return await repository.fetchReviews(wineId);
});
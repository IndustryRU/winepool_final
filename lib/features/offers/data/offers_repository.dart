import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers.dart';

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository(ref.read(supabaseClientProvider));
});

class OffersRepository {
  final SupabaseClient _supabaseClient;

  OffersRepository(this._supabaseClient);

  Future<List<Offer>> fetchAllOffers() async {
    final response = await _supabaseClient
        .from('offers')
        .select('*, wines(*, wineries(*)), profiles(id, username, full_name, shop_name)')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((json) => Offer.fromJson(json)).toList();
  }

  Future<List<Offer>> fetchMyOffers() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final response = await _supabaseClient
        .from('offers')
        .select('*, wines(*, wineries(*)), profiles(id, username, full_name, shop_name)')
        .eq('seller_id', userId)
        .order('created_at', ascending: false);

    return response.map((json) => Offer.fromJson(json)).toList();
  }

  Future<void> addOffer(Offer offer) async {
    await _supabaseClient
        .from('offers')
        .insert(offer.toJson());
  }

  Future<void> updateOffer(Offer offer) async {
    await _supabaseClient
        .from('offers')
        .update(offer.toJson())
        .eq('id', offer.id);
  }

  Future<void> deleteOffer(String offerId) async {
    await _supabaseClient
        .from('offers')
        .update({'is_active': false})
        .match({'id': offerId});
  }

  Future<Offer> fetchOffer(String offerId) async {
    final response = await _supabaseClient
        .from('offers')
        .select('*, wines(*, wineries(*)), profiles(id, username, full_name, shop_name)')
        .eq('id', offerId)
        .single();

    return Offer.fromJson(response);
  }

  Future<String?> uploadOfferImage({required XFile image, required String offerId}) async {
    final imageExtension = image.path.split('.').last;
    final imagePath = '$offerId/image.$imageExtension';
    
    await _supabaseClient.storage.from('offers').upload(
          imagePath,
          File(image.path),
          fileOptions: const FileOptions(upsert: true),
        );

    return _supabaseClient.storage.from('offers').getPublicUrl(imagePath);
  }
}
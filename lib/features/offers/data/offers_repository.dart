import 'dart:developer';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers.dart';
import '../../wines/domain/grape_variety.dart';

final offersRepositoryProvider = Provider<OffersRepository>((ref) {
  return OffersRepository(ref.read(supabaseClientProvider));
});

class OffersRepository {
  final SupabaseClient _supabaseClient;

  OffersRepository(this._supabaseClient);

  Future<List<Offer>> fetchAllOffers() async {
    final response = await _supabaseClient
        .from('offers')
        .select('*, wine:wines(*, winery:wineries(*), grape_varieties(*)), seller:profiles(*)')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((json) => Offer.fromJson(json)).toList();
  }

  Future<List<Offer>> fetchMyOffers() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final response = await _supabaseClient
        .from('offers')
        .select('*, wine:wines(*, winery:wineries(*), grape_varieties(*)), seller:profiles(*)')
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
    // Выполняем специфический запрос для деталей предложения
    final offerData = await _supabaseClient
        .from('offers')
        .select('*, wine:wines(*, winery:wineries(*)), seller:profiles(*)')
        .eq('id', offerId)
        .single();
    
    log('RAW DATA FROM SUPABASE: $offerData');
    
    // Преобразуем алиасы в правильные имена для десериализации
    final transformedData = _transformOfferData(offerData);
    
    final offer = Offer.fromJson(transformedData);
    log('PARSED OFFER: ${offer.toString()}');
    log('WINE OBJECT IS NULL: ${offer.wine == null}');
    if(offer.wine != null) {
      log('PARSED WINE: ${offer.wine.toString()}');
    }
    
    // Шаг 2: Дополнительный запрос - получаем сорта для вина
    if (offer.wine != null && offer.wine!.id != null) {
      final wineId = offer.wine!.id!;
      
      // Запрос сортов для этого вина
      final wineWithGrapesData = await _supabaseClient
          .from('wines')
          .select('grape_varieties(*)')
          .eq('id', wineId)
          .single();

      // Десериализация только сортов
      final grapes = (wineWithGrapesData['grape_varieties'] as List)
          .map((g) => GrapeVariety.fromJson(g))
          .toList();
      
      // Создаем новый объект вина с обновленным списком сортов
      final updatedWine = offer.wine!.copyWith(grapeVarieties: grapes);
      
      // Возвращаем новый объект Offer с обновленным вином
      return offer.copyWith(wine: updatedWine);
    }
    
    return offer;
  }

  // Метод для преобразования данных с алиасами в правильные имена полей
  Map<String, dynamic> _transformOfferData(Map<String, dynamic> data) {
    final transformed = Map<String, dynamic>.from(data);
    
    // Преобразуем алиас 'wine' в 'wines' для правильной десериализации вина
    if (transformed.containsKey('wine')) {
      final wineData = transformed.remove('wine');
      // Рекурсивно преобразуем вложенные данные вина
      transformed['wines'] = _transformWineData(wineData);
    }
    
    // Преобразуем алиас 'seller' в 'profiles' для правильной десериализации продавца
    if (transformed.containsKey('seller')) {
      transformed['profiles'] = transformed.remove('seller');
    }
    
    return transformed;
  }

  // Метод для преобразования данных вина с алиасами в правильные имена полей
  Map<String, dynamic> _transformWineData(Map<String, dynamic> data) {
    final transformed = Map<String, dynamic>.from(data);
    
    // Преобразуем алиас 'winery' в 'wineries' для правильной десериализации винодельни
    if (transformed.containsKey('winery')) {
      transformed['wineries'] = transformed.remove('winery');
    }
    
    return transformed;
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

import 'dart:developer';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/offers/domain/bottle_size.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/providers/supabase_provider.dart';
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
        .select('*, wine:wines(*, winery:wineries(*), grape_varieties(*)), seller:profiles(*), bottle_size:bottle_sizes(*))')
        .eq('is_active', true)
        .order('created_at', ascending: false);

    return response.map((json) => _deserializeOfferWithBottleSize(json)).toList();
  }

 Future<List<Offer>> fetchMyOffers() async {
    final userId = _supabaseClient.auth.currentUser!.id;
    final response = await _supabaseClient
        .from('offers')
        .select('*, wine:wines(*, winery:wineries(*), grape_varieties(*)), seller:profiles(*), bottle_size:bottle_sizes(*))')
        .eq('seller_id', userId)
        .order('created_at', ascending: false);

    return response.map((json) => _deserializeOfferWithBottleSize(json)).toList();
  }

 Future<void> addOffer(Offer offer) async {
    final offerData = _prepareOfferData(offer);
    await _supabaseClient
        .from('offers')
        .insert(offerData);
  }

  Future<void> updateOffer(Offer offer) async {
    final offerData = _prepareOfferData(offer);
    await _supabaseClient
        .from('offers')
        .update(offerData)
        .eq('id', offer.id);
  }

  // Вспомогательный метод для подготовки данных предложения с корректным именем поля bottle_size_id
 Map<String, dynamic> _prepareOfferData(Offer offer) {
    final offerData = offer.toJson();
    // Заменяем bottle_size на bottle_size_id, если bottleSize доступен
    if (offer.bottleSize != null) {
      offerData['bottle_size_id'] = offer.bottleSize!.id;
    } else if (offer.bottleSizeId != null) {
      offerData['bottle_size_id'] = offer.bottleSizeId;
    }
    // Удаляем старое поле bottle_size, если оно есть
    offerData.remove('bottle_size');
    return offerData;
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
        .select('*, wine:wines(*, winery:wineries(*), grape_varieties(*)), seller:profiles(*), bottle_size:bottle_sizes(*)')
        .eq('id', offerId)
        .single();
    
    log('RAW DATA FROM SUPABASE: $offerData');
    
    // Преобразуем алиасы в правильные имена для десериализации
    final transformedData = _transformOfferData(offerData);
    
    final offer = _deserializeOfferWithBottleSize(transformedData);
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

  Future<List<BottleSize>> getAllBottleSizes() async {
    final data = await _supabaseClient.from('bottle_sizes').select();
    return (data as List).map((json) => BottleSize.fromJson(json)).toList();
  }

  // Вспомогательный метод для десериализации предложения с включением информации о размере бутылки
  Offer _deserializeOfferWithBottleSize(Map<String, dynamic> json) {
    final offer = Offer.fromJson(json);
    
    // Если в JSON есть вложенная информация о размере бутылки в поле bottle_size
    if (json['bottle_size'] != null && json['bottle_size'] is Map) {
      final bottleSize = BottleSize.fromJson(json['bottle_size']);
      // Возвращаем копию с установленным bottleSize
      return offer.copyWith(bottleSize: bottleSize);
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
    
    // Преобразуем алиас 'bottle_size' в 'bottle_size' для правильной десериализации размера бутылки
    if (transformed.containsKey('bottle_size')) {
      final bottleSizeData = transformed.remove('bottle_size');
      transformed['bottle_size'] = bottleSizeData;
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

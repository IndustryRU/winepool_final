import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/models.dart';
import '../domain/analytics_models.dart';

final cellarRepositoryProvider = Provider<CellarRepository>((ref) {
  return CellarRepository();
});

class CellarRepository {
  final _client = Supabase.instance.client;

 Future<List<UserTasting>> getUserTastings() async {
    try {
      final response = await _client.rpc('get_user_tastings');

      if (response is List) {
        return (response as List)
            .map((json) => UserTasting.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid response format for getUserTastings');
      }
    } catch (e) {
      throw Exception('Failed to get user tastings: $e');
    }
 }

  Future<void> addUserTasting({
    required String wineId,
    required double rating,
    String? notes,
    String? photoUrl,
    DateTime? tastingDate,
  }) async {
    try {
      final params = {
        'p_wine_id': wineId,
        'p_rating': rating,
        'p_notes': notes,
        'p_photo_url': photoUrl,
        'p_tasting_date': tastingDate?.toIso8601String(),
      };
      
      await _client.rpc('add_user_tasting', params: params);
    } catch (e) {
      throw Exception('Failed to add user tasting: $e');
    }
  }

 Future<void> deleteUserTasting(String tastingId) async {
    try {
      await _client.rpc('delete_user_tasting', params: {'p_tasting_id': tastingId});
    } catch (e) {
      throw Exception('Failed to delete user tasting: $e');
    }
  }

  Future<List<UserStorageItem>> getUserStorage() async {
    try {
      final response = await _client.rpc('get_user_storage');
      
      if (response is List) {
        return (response as List)
            .map((json) => UserStorageItem.fromJson(json))
            .toList();
      } else {
        throw Exception('Invalid response format for getUserStorage');
      }
    } catch (e) {
      throw Exception('Failed to get user storage: $e');
    }
 }

  Future<UserStorageItem> addToUserStorage({
    required String wineId,
    required int quantity,
    double? purchasePrice,
    DateTime? purchaseDate,
    int? idealDrinkFrom,
    int? idealDrinkTo,
  }) async {
    try {
      final params = {
        'p_wine_id': wineId,
        'p_quantity': quantity,
        'p_purchase_price': purchasePrice,
        'p_purchase_date': purchaseDate?.toIso8601String(),
        'p_ideal_drink_from': idealDrinkFrom,
        'p_ideal_drink_to': idealDrinkTo,
      };
      
      final response = await _client.rpc('add_to_user_storage', params: params);
      
      if (response is List && response.isNotEmpty) {
        final allStorageItems = (response as List).map((json) => UserStorageItem.fromJson(json)).toList();
        return allStorageItems.first;
      } else {
        throw Exception('Invalid response format for addToUserStorage');
      }
    } catch (e) {
      throw Exception('Failed to add to user storage: $e');
    }
  }

 Future<void> updateStorageItemQuantity({
    required String itemId,
    required int newQuantity,
  }) async {
    try {
      await _client.rpc(
        'update_storage_item_quantity',
        params: {'p_item_id': itemId, 'p_new_quantity': newQuantity},
      );
    } catch (e) {
      throw Exception('Failed to update storage item quantity: $e');
    }
  }

  Future<AnalyticsData> getAnalytics() async {
    try {
      final response = await _client.rpc('get_user_analytics');
      return AnalyticsData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user analytics: $e');
    }
  }
}
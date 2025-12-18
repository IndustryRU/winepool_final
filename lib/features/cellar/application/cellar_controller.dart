import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/cellar/data/cellar_repository.dart';
import '../domain/models.dart';
import '../domain/analytics_models.dart';

part 'cellar_controller.g.dart';

// Модель для объединения данных
class CellarData {
  final List<UserTasting> tastings;
  final List<UserStorageItem> storageItems;
  CellarData({required this.tastings, required this.storageItems});
}

@riverpod
class CellarController extends _$CellarController {
  @override
  Future<CellarData> build() async {
    final cellarRepository = ref.watch(cellarRepositoryProvider);
    final tastings = await cellarRepository.getUserTastings();
    final storageItems = await cellarRepository.getUserStorage();
    return CellarData(tastings: tastings, storageItems: storageItems);
  }

  // Методы для добавления, обновления, удаления
  Future<void> addTasting({
    required String wineId,
    required double rating,
    String? notes,
    String? photoUrl,
    DateTime? tastingDate,
 }) async {
    try {
      final cellarRepository = ref.read(cellarRepositoryProvider);
      await cellarRepository.addUserTasting(
        wineId: wineId,
        rating: rating,
        notes: notes,
        photoUrl: photoUrl,
        tastingDate: tastingDate,
      );
    } catch (e) {
      throw Exception('Failed to add tasting: $e');
    }
  }

  Future<void> deleteTasting(String tastingId) async {
    try {
      final cellarRepository = ref.read(cellarRepositoryProvider);
      await cellarRepository.deleteUserTasting(tastingId);
    } catch (e) {
      throw Exception('Failed to delete tasting: $e');
    }
  }

  Future<void> addToStorage({
    required String wineId,
    required int quantity,
    double? purchasePrice,
    DateTime? purchaseDate,
    int? idealDrinkFrom,
    int? idealDrinkTo,
    String? userId,
  }) async {
    print(
        '[CellarController] addToStorage called with: userId=$userId, wineId=$wineId, quantity=$quantity');
    try {
      final cellarRepository = ref.read(cellarRepositoryProvider);
      final finalUserId = userId ?? ref.read(authControllerProvider).value?.id;

      if (finalUserId == null) {
        throw Exception('User ID is not available.');
      }

      await cellarRepository.addToUserStorage(
        userId: finalUserId,
        wineId: wineId,
        quantity: quantity,
        purchasePrice: purchasePrice,
        purchaseDate: purchaseDate,
        idealDrinkFrom: idealDrinkFrom,
        idealDrinkTo: idealDrinkTo,
      );
    } catch (e, st) {
      print('[CellarController] Error in addToStorage: $e\n$st');
      // Повторно выбрасываем исключение, чтобы вызывающий код мог его обработать
      rethrow;
    }
  }

  Future<void> updateStorageQuantity({
    required String itemId,
    required int newQuantity,
  }) async {
    try {
      final cellarRepository = ref.read(cellarRepositoryProvider);
      await cellarRepository.updateStorageItemQuantity(
        itemId: itemId,
        newQuantity: newQuantity,
      );
    } catch (e) {
      throw Exception('Failed to update storage quantity: $e');
    }
  }
}

// Отдельный провайдер для дегустаций
@riverpod
Future<List<UserTasting>> cellarTastings(Ref ref) async {
  final cellarRepository = ref.watch(cellarRepositoryProvider);
  return await cellarRepository.getUserTastings();
}

// Отдельный провайдер для хранимых вин
@riverpod
Future<List<UserStorageItem>> cellarStorage(Ref ref) async {
  final cellarRepository = ref.watch(cellarRepositoryProvider);
  return await cellarRepository.getUserStorage();
}

@riverpod
Future<AnalyticsData> analytics(Ref ref) async {
  final cellarRepository = ref.watch(cellarRepositoryProvider);
  return await cellarRepository.getAnalytics();
}
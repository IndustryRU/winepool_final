import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/catalog_controller.dart';
import 'package:winepool_final/features/offers/application/offers_controller.dart';
import 'package:winepool_final/features/wines/data/wines_repository.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';

part 'wines_controller.g.dart';

@riverpod
Future<List<Wine>> winesController(Ref ref) async {
  print('--- BUILDING WINES CONTROLLER ---');
  final winesRepository = ref.watch(winesRepositoryProvider);
 final wines = await winesRepository.fetchAllWines();
  print('--- FETCHED WINES ---');
  print(wines);
  print('--- END OF FETCHED WINES ---');
  return wines;
}

@riverpod
Future<List<Wine>> winesByWinery(Ref ref, String? wineryId) async {
  final winesRepository = ref.watch(winesRepositoryProvider);
  return wineryId != null
      ? winesRepository.fetchWinesByWinery(wineryId)
      : [];
}

@riverpod
Future<List<Wine>> allWines(Ref ref) {
  final winesRepository = ref.watch(winesRepositoryProvider);
  return winesRepository.fetchAllWinesNoFilter();
}

@riverpod
Future<List<Wine>> popularWines(Ref ref) async {
  final winesRepository = ref.watch(winesRepositoryProvider);
  return winesRepository.fetchPopularWines();
}

@riverpod
Future<List<Wine>> newWines(Ref ref) async {
  final winesRepository = ref.watch(winesRepositoryProvider);
  return winesRepository.fetchNewWines();
}

@riverpod
Future<List<Wine>> winesWithFilters(Ref ref, Map<String, dynamic> filters) async {
  final winesRepository = ref.watch(winesRepositoryProvider);
  final result = await winesRepository.fetchWines(filters);
  return result;
}

// Новый провайдер, который наблюдает за catalogFiltersProvider
@riverpod
Future<List<Wine>> winesWithActiveFilters(Ref ref) async {
  final filters = ref.watch(catalogFiltersProvider);
  print('--- WINES WITH ACTIVE FILTERS PROVIDER REFRESHED ---');
  print('Filters: $filters');
  final winesRepository = ref.watch(winesRepositoryProvider);
  final result = await winesRepository.fetchWines(filters);
 return result;
}

@Riverpod(keepAlive: true)
class WineMutation extends _$WineMutation {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> addWine(Wine wine) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(winesRepositoryProvider).addWine(wine);
      // Инвалидируем список вин для конкретной винодельни
      if (wine.wineryId != null) {
        ref.invalidate(winesByWineryProvider(wine.wineryId!));
      }
      ref.invalidate(offersControllerProvider);
    });
  }

  Future<void> updateWine(Wine wine) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(winesRepositoryProvider).updateWine(wine);
      if (wine.wineryId != null) {
        ref.invalidate(winesByWineryProvider(wine.wineryId!));
      }
      ref.invalidate(offersControllerProvider);
    });
  }

  Future<void> deleteWine(String wineId, String? wineryId) async {
    state = const AsyncLoading();
    // Просто выполняем операцию, без инвалидации
    state = await AsyncValue.guard(() async {
      await ref.read(winesRepositoryProvider).deleteWine(wineId);
      if (wineryId != null) {
        ref.invalidate(winesByWineryProvider(wineryId));
      }
    });
  }
}
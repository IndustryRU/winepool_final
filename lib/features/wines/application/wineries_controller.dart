import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/admin/providers/admin_view_settings_provider.dart';
import 'package:winepool_final/features/wines/data/wineries_repository.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

part 'wineries_controller.g.dart';

@riverpod
class WineriesController extends _$WineriesController {
  @override
  FutureOr<List<Winery>> build() {
    final showDeleted = ref.watch(adminViewSettingsProvider);
    return ref.watch(wineriesRepositoryProvider).fetchAllWineries(includeDeleted: showDeleted);
  }

 Future<bool> addWinery(Winery winery) async {
    try {
      await ref.read(wineriesRepositoryProvider).addWinery(winery);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateWinery(Winery winery) async {
    try {
      await ref.read(wineriesRepositoryProvider).updateWinery(winery);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteWinery(String wineryId) async {
    try {
      await ref.read(wineriesRepositoryProvider).deleteWinery(wineryId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreWinery(String wineryId) async {
    try {
      await ref.read(wineriesRepositoryProvider).restoreWinery(wineryId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final fetchWineryByIdProvider = FutureProvider.family<Winery, String>((ref, id) {
  final repository = ref.watch(wineriesRepositoryProvider);
  return repository.fetchWineryById(id);
});
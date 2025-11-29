import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/offers/data/offers_repository.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

part 'all_offers_controller.g.dart';

@riverpod
class AllOffersController extends _$AllOffersController {
  @override
  Future<List<Offer>> build() async {
    final offersRepository = ref.watch(offersRepositoryProvider);
    return await offersRepository.fetchAllOffers();
  }
}
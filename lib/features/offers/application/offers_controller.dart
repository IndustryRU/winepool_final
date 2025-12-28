import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/offers/data/offers_repository.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

part 'offers_controller.g.dart';

@Riverpod(keepAlive: true)
class OffersController extends _$OffersController {
  @override
  Future<List<Offer>> build() async {
    print('--- Rebuilding OffersController ---');
    return await ref.watch(offersRepositoryProvider).fetchMyOffers();
  }

  Future<void> addOffer(Offer offer) async {
    final offersRepository = ref.read(offersRepositoryProvider);
    await offersRepository.addOffer(offer);
  }

  Future<void> updateOffer(Offer offer) async {
    final offersRepository = ref.read(offersRepositoryProvider);
    await offersRepository.updateOffer(offer);
  }
  Future<void> deleteOffer(String offerId) async {
    final offersRepository = ref.read(offersRepositoryProvider);
    await offersRepository.deleteOffer(offerId);
  }
}

@Riverpod(keepAlive: true)
Future<List<Offer>> myOffersController(Ref ref) async {
  print('--- Rebuilding MyOffersController ---');
  return await ref.watch(offersRepositoryProvider).fetchMyOffers();
}

class OffersMutationNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> addOffer(Offer offer) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(offersRepositoryProvider).addOffer(offer);
      ref.invalidate(offersControllerProvider);
    });
  }
}

final offersMutationProvider = 
    AsyncNotifierProvider<OffersMutationNotifier, void>(OffersMutationNotifier.new);

// Новый провайдер для вычисления минимальной и максимальной цены вина на основе его офферов
@riverpod
Future<(double, double)?> winePriceRangeProvider(
  Ref ref,
  String wineId,
) async {
  final offersRepository = ref.read(offersRepositoryProvider);
  
  // Получаем все активные офферы для данного вина
  final allOffers = await offersRepository.fetchAllOffers();
  final wineOffers = allOffers
      .where((offer) => offer.wineId == wineId && offer.isActive)
      .where((offer) => offer.price != null)
      .toList();
  
  if (wineOffers.isEmpty) {
    return null;
  }
  
  // Находим минимальную и максимальную цену
  double minPrice = wineOffers[0].price!;
  double maxPrice = wineOffers[0].price!;
  
  for (final offer in wineOffers) {
    if (offer.price! < minPrice) {
      minPrice = offer.price!;
    }
    if (offer.price! > maxPrice) {
      maxPrice = offer.price!;
    }
  }
  
  return (minPrice, maxPrice);
}
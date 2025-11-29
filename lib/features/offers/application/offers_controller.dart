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
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import '../data/offers_repository.dart';

final offerDetailsControllerProvider = FutureProvider.family<Offer, String>((ref, offerId) async {
  final repository = ref.read(offersRepositoryProvider);
  return await repository.fetchOffer(offerId);
});
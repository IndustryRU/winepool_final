import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/offers/application/offers_controller.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

class EditOfferScreen extends HookConsumerWidget {
  const EditOfferScreen({super.key, required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceController = useTextEditingController(text: offer.price?.toString());
    final vintageController = useTextEditingController(text: offer.vintage?.toString());
    final bottleSizeController = useTextEditingController(text: offer.bottleSize?.toString());
    final formKey = useMemoized(() => GlobalKey<FormState>());

    ref.listen(offersMutationProvider, (previous, next) {
      if (next is AsyncError) {
        // TODO: Показать ошибку пользователю
        print('Ошибка при обновлении предложения: ${next.error}');
      } else if (next is AsyncData && previous is AsyncLoading) {
        // Предложение успешно обновлено, закрываем экран
        if (context.mounted) {
          context.pop();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать предложение'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              // Отображение информации о вине из offer.wine
              if (offer.wine != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (offer.wine?.imageUrl != null && Uri.parse(offer.wine!.imageUrl!).isAbsolute)
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(offer.wine!.imageUrl!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: const Icon(Icons.wine_bar, size: 50),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          offer.wine?.name ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.wine?.winery?.name ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        if (offer.wine?.alcoholLevel != null)
                          Text('Крепость: ${offer.wine!.alcoholLevel}%'),
                        Text('Цвет: ${offer.wine?.color?.name ?? 'N/A'}'),
                        Text('Сахар: ${offer.wine?.sugar?.name ?? 'N/A'}'),
                        if (offer.wine?.description != null)
                          Text('Описание: ${offer.wine!.description ?? ''}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Пожалуйста, введите корректную цену';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: vintageController,
                decoration: const InputDecoration(
                  labelText: 'Год урожая',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bottleSizeController,
                decoration: const InputDecoration(
                  labelText: 'Объем бутылки (л)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  print('--- Save Button Pressed ---');
                  if (formKey.currentState!.validate()) {
                    print('--- Form Validated ---');
                    final updatedOffer = offer.copyWith(
                      price: double.parse(priceController.text),
                      vintage: int.parse(vintageController.text),
                      bottleSize: double.parse(bottleSizeController.text),
                    );
                    print('--- Updating Offer ---');
                    await ref.read(offersControllerProvider.notifier).updateOffer(updatedOffer);
                    print('--- Offer Updated ---');
                    
                    // Явно инвалидируем список, чтобы он обновился
                    ref.invalidate(offersControllerProvider);
                    
                    if (context.mounted) context.pop();
                  } else {
                    print('--- Form Validation Failed ---');
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
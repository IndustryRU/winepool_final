import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/filter_options_provider.dart';
import 'package:winepool_final/features/catalog/application/temporary_selection_providers.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

class PriceFilterWidget extends HookConsumerWidget {
  const PriceFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceRangeAsync = ref.watch(priceRangeProvider);
    final tempPriceNotifier = ref.read(temporaryPriceRangeProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('Цена', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.invalidate(temporaryPriceRangeProvider);
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  final tempPriceRange = ref.read(temporaryPriceRangeProvider);
                  ref.read(catalogFiltersProvider.notifier).updateFilters(
                    ref.read(catalogFiltersProvider).copyWith(
                      minPrice: tempPriceRange.$1,
                      maxPrice: tempPriceRange.$2,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        priceRangeAsync.when(
          loading: () => const Center(child: ShimmerLoadingIndicator()),
          error: (err, stack) => Center(child: Text('Ошибка: $err')),
          data: (range) {
            final currencyFormatter = NumberFormat.currency(
                locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
            final decimalFormatter = NumberFormat.decimalPattern('ru_RU');

            double minAvailable = range['min_price']!;
            double maxAvailable = range['max_price']!;

            if (minAvailable >= maxAvailable) {
              maxAvailable = minAvailable + 100;
            }

            final tempPriceRange = ref.watch(temporaryPriceRangeProvider);
            final isInitialized = tempPriceRange.$1 != null;

            useEffect(() {
              if (!isInitialized) {
                final initialFilters = ref.read(catalogFiltersProvider);
                final min = initialFilters.minPrice ?? minAvailable;
                final max = initialFilters.maxPrice ?? maxAvailable;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  tempPriceNotifier.setRange(min, max);
                });
              }
              return null;
            }, [isInitialized, minAvailable, maxAvailable]);

            final double currentMin = tempPriceRange.$1 ?? minAvailable;
            final double currentMax = tempPriceRange.$2 ?? maxAvailable;

            final minController = useTextEditingController(
                text: decimalFormatter.format(currentMin.toInt()));
            final maxController = useTextEditingController(
                text: decimalFormatter.format(currentMax.toInt()));

            useEffect(() {
              final formattedMin = decimalFormatter.format(currentMin.toInt());
              if (minController.text != formattedMin) {
                minController.text = formattedMin;
              }
              final formattedMax = decimalFormatter.format(currentMax.toInt());
              if (maxController.text != formattedMax) {
                maxController.text = formattedMax;
              }
              return null;
            }, [currentMin, currentMax]);

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  RangeSlider(
                    min: minAvailable,
                    max: maxAvailable,
                    values: RangeValues(currentMin, currentMax),
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.withOpacity(0.3),
                    labels: RangeLabels(
                      currencyFormatter.format(currentMin),
                      currencyFormatter.format(currentMax),
                    ),
                    onChanged: (values) {
                      tempPriceNotifier.setRange(values.start, values.end);
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minController,
                          decoration: const InputDecoration(
                            labelText: 'От',
                            suffixText: '₽',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final min =
                                double.tryParse(value.replaceAll(' ', ''));
                            if (min != null) {
                              tempPriceNotifier.setMin(
                                  min.clamp(minAvailable, currentMax));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: maxController,
                          decoration: const InputDecoration(
                            labelText: 'До',
                            suffixText: '₽',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final max =
                                double.tryParse(value.replaceAll(' ', ''));
                            if (max != null) {
                              tempPriceNotifier.setMax(
                                  max.clamp(currentMin, maxAvailable));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ActionChip(
                        label: const Text('Все цены'),
                        onPressed: () {
                          tempPriceNotifier.setRange(minAvailable, maxAvailable);
                        },
                      ),
                      _buildPriceChip(
                        label: 'до 700 ₽',
                        chipMin: 0,
                        chipMax: 700,
                        availableMin: minAvailable,
                        availableMax: maxAvailable,
                        onPressed: tempPriceNotifier.setRange,
                      ),
                      _buildPriceChip(
                        label: '700 - 1200 ₽',
                        chipMin: 700,
                        chipMax: 1200,
                        availableMin: minAvailable,
                        availableMax: maxAvailable,
                        onPressed: tempPriceNotifier.setRange,
                      ),
                      _buildPriceChip(
                        label: '1200 - 1800 ₽',
                        chipMin: 1200,
                        chipMax: 1800,
                        availableMin: minAvailable,
                        availableMax: maxAvailable,
                        onPressed: tempPriceNotifier.setRange,
                      ),
                      _buildPriceChip(
                        label: '1800 - 2500 ₽',
                        chipMin: 1800,
                        chipMax: 2500,
                        availableMin: minAvailable,
                        availableMax: maxAvailable,
                        onPressed: tempPriceNotifier.setRange,
                      ),
                      _buildPriceChip(
                        label: 'от 2500 ₽',
                        chipMin: 2500,
                        chipMax: double.infinity,
                        availableMin: minAvailable,
                        availableMax: maxAvailable,
                        onPressed: tempPriceNotifier.setRange,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
  Widget _buildPriceChip({
    required String label,
    required double chipMin,
    required double chipMax,
    required double availableMin,
    required double availableMax,
    required void Function(double, double) onPressed,
  }) {
    // Диапазон чипа не пересекается с доступным диапазоном
    final bool isDisabled = chipMax < availableMin || chipMin > availableMax;

    return ActionChip(
      label: Text(label),
      onPressed: isDisabled
          ? null
          : () {
              // "Прижимаем" значения чипа к доступному диапазону
              final double start = chipMin.clamp(availableMin, availableMax);
              final double end = chipMax.clamp(availableMin, availableMax);
              onPressed(start, end);
            },
    );
  }
}
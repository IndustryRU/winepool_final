import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/cellar/application/cellar_controller.dart';
import 'package:winepool_final/features/cellar/domain/analytics_models.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    return analytics.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: SelectableText.rich(
          TextSpan(
            text: 'Ошибка загрузки аналитики: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      data: (data) {
        if (data == null) {
          return const Center(
            child: Text('Нет данных для аналитики.'),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _AverageRating(rating: data.averageRating),
            const SizedBox(height: 24),
            if (data.tasteWeb != null)
              _TasteWebChart(tasteWeb: data.tasteWeb!),
            const SizedBox(height: 24),
            _TopVarieties(topVarieties: data.topVarieties),
            const SizedBox(height: 24),
            _TopCountries(topCountries: data.topCountries),
          ],
        );
      },
    );
  }
}

class _AverageRating extends StatelessWidget {
  final double? rating;

  const _AverageRating({this.rating});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Средний рейтинг',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              rating?.toStringAsFixed(2) ?? 'N/A',
              style: textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TasteWebChart extends StatelessWidget {
  final TasteWeb tasteWeb;

  const _TasteWebChart({required this.tasteWeb});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final data = [
      tasteWeb.sweetness ?? 0.0,
      tasteWeb.acidity ?? 0.0,
      tasteWeb.tannins ?? 0.0,
      tasteWeb.saturation ?? 0.0,
    ];
    final titles = ['Сладость', 'Кислотность', 'Танины', 'Насыщенность'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Паутина Вкуса', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      dataEntries: [
                        for (var i = 0; i < data.length; i++)
                          RadarEntry(value: data[i]),
                      ],
                      borderColor: Theme.of(context).primaryColor,
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.25),
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  borderData: FlBorderData(show: false),
                  radarBorderData: const BorderSide(color: Colors.grey),
                  tickCount: 5,
                  ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 10),
                  tickBorderData: const BorderSide(color: Colors.grey),
                  gridBorderData: const BorderSide(color: Colors.grey, width: 0.5),
                  getTitle: (index, angle) {
                    return RadarChartTitle(
                      text: titles[index],
                      angle: angle,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopVarieties extends StatelessWidget {
  final List<TopVariety> topVarieties;

  const _TopVarieties({required this.topVarieties});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Топ Сортов', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            if (topVarieties.isEmpty)
              const Text('Нет данных.')
            else
              ...topVarieties.map(
                (item) => ListTile(
                  title: Text(item.grapeVariety ?? 'Неизвестный сорт'),
                  trailing: Text(
                    '${item.count}',
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopCountries extends StatelessWidget {
  final List<TopCountry> topCountries;

  const _TopCountries({required this.topCountries});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Топ Стран', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            if (topCountries.isEmpty)
              const Text('Нет данных.')
            else
              ...topCountries.map(
                (item) => ListTile(
                  title: Text(item.countryName ?? 'Неизвестная страна'),
                  trailing: Text(
                    '${item.count}',
                     style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
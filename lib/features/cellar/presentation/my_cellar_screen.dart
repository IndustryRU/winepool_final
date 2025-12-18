import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:winepool_final/features/cellar/presentation/analytics_screen.dart';

import '../application/cellar_controller.dart';
import '../domain/models.dart';
import '../../wines/domain/wine.dart';

class MyCellarScreen extends HookConsumerWidget {
  const MyCellarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 3);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой Погребок'),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(text: 'Пробовал'),
            Tab(text: 'Храню'),
            Tab(text: 'Аналитика'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          // Вкладка "Пробовал"
          ref.watch(cellarTastingsProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: SelectableText.rich(
                TextSpan(
                  text: 'Ошибка загрузки: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            data: (tastings) => _TastedWinesView(tastings),
          ),
          
          // Вкладка "Храню"
          ref.watch(cellarStorageProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: SelectableText.rich(
                TextSpan(
                  text: 'Ошибка загрузки: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            data: (storageItems) => _StoredWinesView(storageItems),
          ),
          const AnalyticsScreen(),
        ],
      ),
    );
 }
}

// Виджет для отображения продегустированных вин
class _TastedWinesView extends StatelessWidget {
  final List<UserTasting> tastings;

  const _TastedWinesView(this.tastings);

  @override
 Widget build(BuildContext context) {
    if (tastings.isEmpty) {
      return const Center(
        child: Text('Вы еще не пробовали вина'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tastings.length,
      itemBuilder: (context, index) {
        final tasting = tastings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        tasting.wine.name ?? 'Название не указано',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Отображение звезд рейтинга
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < (tasting.rating?.floor() ?? 0)
                              ? Icons.star
                              : starIndex < (tasting.rating ?? 0.0)
                                  ? Icons.star_half
                                  : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Винодельня: ${tasting.wine.winery?.name ?? "Не указана"}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Дата дегустации: ${tasting.tastingDate != null ? _formatDate(tasting.tastingDate!) : "Не указана"}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[60],
                  ),
                ),
                if (tasting.notes != null && tasting.notes!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Заметки: ${tasting.notes}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (tasting.photoUrl != null) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      tasting.photoUrl!,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }
}

// Виджет для отображения хранимых вин
class _StoredWinesView extends StatelessWidget {
  final List<UserStorageItem> storageItems;

  const _StoredWinesView(this.storageItems);

  @override
  Widget build(BuildContext context) {
    if (storageItems.isEmpty) {
      return const Center(
        child: Text('У вас нет вин в коллекции'),
      );
    }

    final groupedByWine =
        groupBy<UserStorageItem, Wine>(storageItems, (item) => item.wine);

    final wineGroups = groupedByWine.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: wineGroups.length,
      itemBuilder: (context, index) {
        final wineGroup = wineGroups[index];
        final wine = wineGroup.key;
        final items = wineGroup.value;
        final bottleCount = items.length;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    wine.name ?? 'Название не указано',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'x$bottleCount',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Винодельня: ${wine.winery?.name ?? "Не указана"}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            children: items
                .map((item) => _buildBottleListItem(context, item))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildBottleListItem(BuildContext context, UserStorageItem item) {
    return ListTile(
      title: Text(
        'Цена: ${item.purchasePrice?.toStringAsFixed(2) ?? "N/A"} ₽',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Text(
        'Куплено: ${item.purchaseDate != null ? _formatDate(item.purchaseDate!) : "N/A"}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: OutlinedButton(
        onPressed: () {
          // TODO: Implement "Mark as Tasted" logic
        },
        child: const Text("Пробовал"),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}.${date.month}.${date.year}";
  }
}
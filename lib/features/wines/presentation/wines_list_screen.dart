import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class WinesListScreen extends ConsumerWidget {
  const WinesListScreen({super.key, required this.wineryId});

  final String wineryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winesAsync = ref.watch(winesByWineryProvider(wineryId));

    return WillPopScope(
      onWillPop: () async {
        // Возвращаем на предыдущий экран (список виноделен)
        context.go('/wineries');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вина винодельни'),
        ),
        body: winesAsync.when(
          data: (wines) {
            if (wines.isEmpty) {
              return const Center(child: Text('У этой винодельни пока нет вин.'));
            }
            return ListView.builder(
              itemCount: wines.length,
              itemBuilder: (context, index) {
                final wine = wines[index];
                return ListTile(
                  title: Text(wine.name),
                  // TODO: Добавить onTap для перехода к деталям вина
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push(
                            '/wineries/$wineryId/wines/${wine.id}/edit',
                            extra: wine,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Удалить вино?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(dialogContext).pop(),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (wine.id == null) {
                                      if (dialogContext.mounted) {
                                        // Показываем ошибку, если у вина нет ID
                                        showDialog(
                                          context: dialogContext,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Ошибка'),
                                            content: const Text('Невозможно удалить вино без ID'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return;
                                    }
                                    // Дожидаемся завершения операции
                                    await ref.read(wineMutationProvider.notifier).deleteWine(wine.id!, wineryId);
                                    
                                    // Инвалидируем список из UI
                                    ref.invalidate(winesByWineryProvider(wineryId));

                                    if (dialogContext.mounted) {
                                      Navigator.of(dialogContext).pop();
                                    }
                                  },
                                  child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: ShimmerLoadingIndicator()),
          error: (error, stack) => Center(child: Text('Ошибка: $error')),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/wineries/$wineryId/wines/add');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
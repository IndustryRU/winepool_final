import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/admin/providers/admin_view_settings_provider.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class WinesListScreen extends ConsumerWidget {
  const WinesListScreen({super.key, required this.wineryId});

  final String wineryId;

 @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showDeleted = ref.watch(adminViewSettingsProvider);
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
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _showSettingsBottomSheet(context, ref);
              },
              tooltip: 'Настройки',
            ),
          ],
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
                return _WineItem(
                  wine: wine,
                  wineryId: wineryId,
                  onRestore: () => _restoreWine(ref, wine),
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

  Future<void> _showSettingsBottomSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final showDeleted = ref.watch(adminViewSettingsProvider);
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Настройки отображения'),
                  ),
                  SwitchListTile(
                    title: const Text('Показывать удаленные'),
                    value: showDeleted,
                    onChanged: (value) {
                      ref.read(adminViewSettingsProvider.notifier).state = value;
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

 Future<void> _restoreWine(WidgetRef ref, wine) async {
    final context = ref.context;
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите восстановить это вино?'),
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
                        content: const Text('Невозможно восстановить вино без ID'),
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
                await ref.read(wineMutationProvider.notifier).restoreWine(wine.id!);
                
                // Инвалидируем список из UI
                ref.invalidate(winesByWineryProvider(wineryId));

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Восстановить', style: TextStyle(color: Colors.green)),
            ),
          ],
        ),
      );
    }
 }
}

class _WineItem extends ConsumerWidget {
  const _WineItem({
    required this.wine,
    required this.wineryId,
    required this.onRestore,
  });

  final wine;
  final String wineryId;
 final VoidCallback onRestore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Opacity(
        opacity: wine.isDeleted == true ? 0.5 : 1.0, // Уменьшаем прозрачность для удаленных элементов
        child: Row(
          children: [
            if (wine.isDeleted == true) ...[
              const Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                wine.name ?? 'Название не указано',
                style: TextStyle(
                  color: wine.isDeleted == true ? Colors.grey : null,
                ),
              ),
            ),
          ],
        ),
      ),
      // TODO: Добавить onTap для перехода к деталям вина
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (wine.isDeleted == true) ...[
            IconButton(
              icon: const Icon(Icons.restore_from_trash, color: Colors.green),
              onPressed: onRestore,
            ),
          ] else ...[
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
        ],
      ),
    );
  }
}
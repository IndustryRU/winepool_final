import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/admin/providers/admin_view_settings_provider.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/wines/application/wineries_controller.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class WineriesListScreen extends ConsumerWidget {
  const WineriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wineriesAsync = ref.watch(wineriesControllerProvider);
    final showDeleted = ref.watch(adminViewSettingsProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          context.go('/admin');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/admin');
            },
          ),
          title: const Text('Винодельни'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                _showSettingsBottomSheet(context, ref);
              },
              tooltip: 'Настройки',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
              tooltip: 'Выйти',
            ),
          ],
        ),
        body: wineriesAsync.when(
          data: (wineries) => RefreshIndicator(
            onRefresh: () => ref.refresh(wineriesControllerProvider.future),
            child: ListView.builder(
              itemCount: wineries.length,
              itemBuilder: (context, index) {
                final winery = wineries[index];
                return _WineryItem(
                  winery: winery,
                  onEdit: () {
                    context.push('/wineries/${winery.id}/edit', extra: winery);
                  },
                  onDelete: () => _deleteWinery(ref, winery),
                  onRestore: () => _restoreWinery(ref, winery),
                  onTap: () {
                    // Используем GoRouter для навигации с передачей объекта winery
                    context.push('/wineries/${winery.id}', extra: winery);
                    // Обновляем данные после возвращения с экрана деталей
                    ref.invalidate(wineriesControllerProvider);
                  },
                );
              },
            ),
          ),
          loading: () => const Center(child: ShimmerLoadingIndicator()),
          error: (error, stack) => SelectableText.rich(
            TextSpan(
              text: 'Ошибка: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/wineries/add');
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

 Future<void> _deleteWinery(WidgetRef ref, Winery winery) async {
    final context = ref.context;
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите удалить эту винодельню? Все связанные с ней вина также будут удалены.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (winery.id == null) {
                  if (dialogContext.mounted) {
                    // Показываем ошибку, если у винодельни нет ID
                    showDialog(
                      context: dialogContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content: const Text('Невозможно удалить винодельню без ID'),
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
                await ref.read(wineriesControllerProvider.notifier).deleteWinery(winery.id!);
                // Принудительно инвалидируем провайдер из UI
                ref.invalidate(wineriesControllerProvider);

                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
 }

  Future<void> _restoreWinery(WidgetRef ref, Winery winery) async {
    final context = ref.context;
    if (context.mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Подтверждение'),
          content: const Text('Вы уверены, что хотите восстановить эту винодельню?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (winery.id == null) {
                  if (dialogContext.mounted) {
                    // Показываем ошибку, если у винодельни нет ID
                    showDialog(
                      context: dialogContext,
                      builder: (context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content: const Text('Невозможно восстановить винодельню без ID'),
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
                await ref.read(wineriesControllerProvider.notifier).restoreWinery(winery.id!);
                // Принудительно инвалидируем провайдер из UI
                ref.invalidate(wineriesControllerProvider);

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

class _WineryItem extends StatelessWidget {
  const _WineryItem({
    required this.winery,
    required this.onEdit,
    required this.onDelete,
    required this.onRestore,
    this.onTap,
  });

  final Winery winery;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestore;
  final VoidCallback? onTap;

 @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Opacity(
            opacity: winery.isDeleted == true ? 0.5 : 1.0, // Уменьшаем прозрачность для удаленных элементов
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (winery.isDeleted == true) ...[
                            const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Expanded(
                            child: Text(
                              winery.name ?? 'Без названия',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: winery.isDeleted == true ? Colors.grey : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (winery.isDeleted == true) ...[
                          IconButton(
                            onPressed: onRestore,
                            icon: const Icon(Icons.restore_from_trash, color: Colors.green),
                          ),
                        ] else ...[
                          IconButton(
                            onPressed: onEdit,
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (winery.description != null)
                  Text(
                    winery.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
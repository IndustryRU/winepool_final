import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/wines/application/wineries_controller.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

class WineriesListScreen extends ConsumerWidget {
  const WineriesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wineriesAsync = ref.watch(wineriesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Винодельни'),
        actions: [
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
        loading: () => const Center(child: CircularProgressIndicator()),
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
                await ref.read(wineriesControllerProvider.notifier).deleteWinery(winery.id);
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
}

class _WineryItem extends StatelessWidget {
  const _WineryItem({
    required this.winery,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
  });

  final Winery winery;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

 @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      winery.name ?? 'Без названия',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
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
    );
  }
}
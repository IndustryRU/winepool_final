import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final supabaseClient = ref.watch(supabaseClientProvider);

    return WillPopScope(
      onWillPop: () async {
        // Возвращаем на предыдущий экран (обычно главный экран)
        context.go('/buyer-home');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
        ),
        body: authState.when(
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('Пользователь не авторизован'));
            }

            // Получаем email из сессии
            final session = supabaseClient.auth.currentSession;
            final email = session?.user.email ?? 'Email не указан';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Профиль',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Имя: ${profile.fullName ?? "Не указано"}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: $email',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Реализовать редактирование профиля
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Редактирование профиля пока не реализовано'),
                        ),
                      );
                    },
                    child: const Text('Редактировать профиль'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/profile/ebs-verification');
                    },
                    child: const Text('Подтвердить личность через ЕБС'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/wine-label-ocr');
                    },
                    child: const Text('Распознавание этикетки вина'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Выйти'),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: ShimmerLoadingIndicator()),
          error: (error, stack) => Center(
            child: Text('Ошибка: $error'),
          ),
        ),
      ),
    );
  }
}
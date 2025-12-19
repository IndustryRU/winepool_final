import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/profile/application/ocr_service_controller.dart'; // Импортируем контроллер сервиса
import '../../../common/widgets/shimmer_loading_indicator.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final supabaseClient = ref.watch(supabaseClientProvider);

    return PopScope(
      onPopInvoked: (didPop) async {
        if (!didPop) {
          context.go('/buyer-home');
        }
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
                  // Добавляем переключатель для выбора OCR-сервиса
                  const OcrServiceSwitch(),
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

class OcrServiceSwitch extends ConsumerWidget {
  const OcrServiceSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ocrService = ref.watch(ocrServiceProvider);

    return DropdownButtonFormField<OcrService>(
      value: ocrService,
      decoration: const InputDecoration(
        labelText: 'Сервис OCR',
      ),
      items: const [
        DropdownMenuItem(
          value: OcrService.google,
          child: Text('Google ML Kit'),
        ),
        DropdownMenuItem(
          value: OcrService.tesseract,
          child: Text('Tesseract OCR'),
        ),
        DropdownMenuItem(
          value: OcrService.yandex,
          child: Text('Yandex OCR'),
        ),
      ],
      onChanged: (newService) {
        if (newService != null) {
          ref.read(ocrServiceProvider.notifier).setOcrService(newService);
        }
      },
    );
  }
}
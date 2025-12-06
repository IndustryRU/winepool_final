import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uuid/uuid.dart';
import 'package:winepool_final/features/wines/application/wineries_controller.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditWineryScreen extends HookConsumerWidget {
  const AddEditWineryScreen({super.key, this.winery});

  final Winery? winery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = winery != null;
    final nameController = useTextEditingController(text: winery?.name);
    final descriptionController = useTextEditingController(text: winery?.description);
    final winemakerController = useTextEditingController(text: winery?.winemaker);
    final countryController = useTextEditingController(text: winery?.country);
    final regionController = useTextEditingController(text: winery?.region);
    final locationTextController = useTextEditingController(text: winery?.locationText);
    final websiteController = useTextEditingController(text: winery?.website);
    final logoFile = useState<XFile?>(null);
    final bannerFile = useState<XFile?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Редактировать' : 'Добавить винодельню'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Название'),
                validator: (value) => (value == null || value.isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: winemakerController,
                decoration: const InputDecoration(labelText: 'Винодел'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(labelText: 'Страна'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: regionController,
                decoration: const InputDecoration(labelText: 'Регион'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationTextController,
                decoration: const InputDecoration(labelText: 'Месторасположение'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: 'Веб-сайт'),
              ),
              const SizedBox(height: 16),
              Text('Логотип', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              // Предпросмотр логотипа
              if (logoFile.value != null)
                Image.file(File(logoFile.value!.path), height: 100, fit: BoxFit.contain)
              else if (winery?.logoUrl != null)
                CachedNetworkImage(imageUrl: winery!.logoUrl!, height: 100, fit: BoxFit.contain),
              const SizedBox(height: 8),
              // Кнопка выбора логотипа
              TextButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Загрузить логотип'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  logoFile.value = pickedFile;
                },
              ),
              const SizedBox(height: 16),
              Text('Баннер', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              // Предпросмотр баннера
              if (bannerFile.value != null)
                Image.file(File(bannerFile.value!.path), height: 100, fit: BoxFit.contain)
              else if (winery?.bannerUrl != null)
                CachedNetworkImage(imageUrl: winery!.bannerUrl!, height: 100, fit: BoxFit.contain),
              const SizedBox(height: 8),
              // Кнопка выбора баннера
              TextButton.icon(
                icon: const Icon(Icons.upload_file),
                label: const Text('Загрузить баннер'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  bannerFile.value = pickedFile;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Блокируем кнопку, чтобы избежать двойных нажатий
                  // (если у вас этого еще нет)
                  final controllerState = ref.watch(wineriesControllerProvider);
                  if (controllerState.isLoading) return;

                  try {
                    if (formKey.currentState!.validate()) {
                      // Показываем индикатор загрузки
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Сохранение...')),
                      );

                      String? logoUrl = winery?.logoUrl;
                      if (logoFile.value != null) {
                        final fileName = await ref.read(storageServiceProvider).uploadFile(
                              'winery_logos',
                              logoFile.value!,
                            );
                        logoUrl = Supabase.instance.client.storage
                            .from('winery_logos')
                            .getPublicUrl(fileName);
                      }

                      String? bannerUrl = winery?.bannerUrl;
                      if (bannerFile.value != null) {
                        final fileName = await ref.read(storageServiceProvider).uploadFile(
                              'winery_banners',
                              bannerFile.value!,
                            );
                        bannerUrl = Supabase.instance.client.storage
                            .from('winery_banners')
                            .getPublicUrl(fileName);
                      }

                      final newWinery = Winery(
                        id: winery?.id ?? const Uuid().v4(), // Генерируем ID при добавлении
                        name: nameController.text,
                        description: descriptionController.text,
                        winemaker: winemakerController.text,
                        region: regionController.text,
                        website: websiteController.text,
                        locationText: locationTextController.text,
                        logoUrl: logoUrl, // используем новые URL
                        bannerUrl: bannerUrl, // используем новые URL
                        countryCode: countryController.text,
                      );

                      final success = isEditMode
                          ? await ref.read(wineriesControllerProvider.notifier).updateWinery(newWinery)
                          : await ref.read(wineriesControllerProvider.notifier).addWinery(newWinery);

                      if (success && context.mounted) {
                        ref.invalidate(wineriesControllerProvider); // Инвалидируем список ЗДЕСЬ
                        context.pop();
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ошибка сохранения')),
                        );
                      }
                    } else {
                      // Этот блок покажет, если проблема в валидации
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Пожалуйста, заполните все обязательные поля.')),
                      );
                    }
                  } catch (e) {
                    // Если что-то пошло не так, показываем ошибку
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Произошла ошибка: $e')),
                      );
                    }
                  }
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
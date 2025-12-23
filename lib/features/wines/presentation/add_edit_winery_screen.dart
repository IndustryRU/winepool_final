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
import 'package:winepool_final/features/wines/domain/region.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/wines/data/wineries_repository.dart';

class AddEditWineryScreen extends HookConsumerWidget {
  const AddEditWineryScreen({super.key, this.winery});

  final Winery? winery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = winery != null;
    final nameController = useTextEditingController(text: winery?.name);
    final descriptionController = useTextEditingController(text: winery?.description);
    final winemakerController = useTextEditingController(text: winery?.winemaker);
    final countryController = useTextEditingController();
    final regionController = useTextEditingController(text: winery?.regionName);
    final locationTextController = useTextEditingController(text: winery?.locationText);
    final websiteController = useTextEditingController(text: winery?.website);
    final latitudeController = useTextEditingController(text: winery?.latitude?.toString());
    final longitudeController = useTextEditingController(text: winery?.longitude?.toString());
    final foundedYearController = useTextEditingController(text: winery?.foundedYear?.toString());
    final phoneController = useTextEditingController(text: winery?.phone);
    final emailController = useTextEditingController(text: winery?.email);
    final isPartnerController = useState<bool>(winery?.isPartner ?? false);
    final logoFile = useState<XFile?>(null);
    final bannerFile = useState<XFile?>(null);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final regionsAsync = useState<AsyncValue<List<Region>>>(const AsyncValue.loading());
    final selectedRegion = useState<Region?>(null);
    final countriesAsync = useState<AsyncValue<List<Country>>>(const AsyncValue.loading());
    final selectedCountry = useState<Country?>(null);

    // Загружаем регионы при инициализации
    useEffect(() {
      final loadData = () async {
        try {
          final repository = ref.read(wineriesRepositoryProvider);
          // Загружаем страны и регионы параллельно
          final results = await Future.wait([
            repository.getRegions(),
            repository.getCountries(),
          ]);
          final regions = results[0] as List<Region>;
          final countries = results[1] as List<Country>;

          regionsAsync.value = AsyncValue.data(regions);
          countriesAsync.value = AsyncValue.data(countries);
          
          if (isEditMode && winery != null) {
            // Устанавливаем выбранную страну
            if (winery!.countryCode != null) {
              final currentCountry = countries.firstWhere(
                (c) => c.code == winery!.countryCode,
                // orElse: () => null, // Не нужно, так как мы хотим найти или ничего
              );
              selectedCountry.value = currentCountry;
              countryController.text = currentCountry.name;
            }

            // Устанавливаем выбранный регион
            if (winery!.regionId != null) {
              final currentRegion = regions.firstWhere(
                (region) => region.id == winery!.regionId,
                orElse: () => Region(id: winery!.regionId, name: winery?.regionName ?? '', countryCode: winery?.countryCode ?? ''),
              );
              selectedRegion.value = currentRegion;
              regionController.text = currentRegion.name ?? '';
            }
          }
        } catch (e, st) {
          regionsAsync.value = AsyncValue.error(e, st);
          countriesAsync.value = AsyncValue.error(e, st);
        }
      };
      
      loadData();
      return null;
    }, [isEditMode, winery]);

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
              countriesAsync.value.when(
                data: (countries) {
                  return DropdownButtonFormField<Country>(
                    value: selectedCountry.value,
                    decoration: const InputDecoration(labelText: 'Страна'),
                    items: countries
                        .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country.name),
                            ))
                        .toList(),
                    onChanged: (Country? newValue) {
                      selectedCountry.value = newValue;
                      countryController.text = newValue?.name ?? '';
                      // Опционально: сбрасывать регион при смене страны
                      selectedRegion.value = null;
                      regionController.text = '';
                    },
                    validator: (value) => value == null ? 'Выберите страну' : null,
                  );
                },
                loading: () => DropdownButtonFormField<Country>(
                  decoration: const InputDecoration(labelText: 'Страна'),
                  items: const [],
                  onChanged: (Country? value) {},
                  hint: const Text('Загрузка...'),
                ),
                error: (error, stack) => DropdownButtonFormField<Country>(
                  decoration: const InputDecoration(labelText: 'Страна', errorText: 'Ошибка загрузки'),
                  items: const [],
                  onChanged: (Country? value) {},
                ),
              ),
              const SizedBox(height: 16),
              regionsAsync.value!.when(
                data: (regions) {
                  final filteredRegions = selectedCountry.value == null
                      ? <Region>[]
                      : regions.where((r) => r.countryCode == selectedCountry.value!.code).toList();

                  // Если текущий выбранный регион не входит в отфильтрованный список, сбрасываем его
                  if (selectedRegion.value != null && !filteredRegions.contains(selectedRegion.value)) {
                    selectedRegion.value = null;
                    regionController.text = '';
                  }

                  return DropdownButtonFormField<Region>(
                    value: selectedRegion.value,
                    decoration: InputDecoration(
                      labelText: 'Регион',
                      enabled: selectedCountry.value != null && filteredRegions.isNotEmpty,
                      hintText: selectedCountry.value == null
                          ? 'Сначала выберите страну'
                          : filteredRegions.isEmpty
                              ? 'Нет регионов для этой страны'
                              : null,
                    ),
                    items: filteredRegions
                        .map((region) => DropdownMenuItem(
                              value: region,
                              child: Text(region.name ?? ''),
                            ))
                        .toList(),
                    onChanged: (selectedCountry.value != null && filteredRegions.isNotEmpty)
                      ? (Region? newValue) {
                          selectedRegion.value = newValue;
                          regionController.text = newValue?.name ?? '';
                        }
                      : null,
                    validator: (value) {
                      if (selectedCountry.value != null && filteredRegions.isNotEmpty && value == null) {
                        return 'Выберите регион';
                      }
                      return null;
                    },
                  );
                },
                loading: () => DropdownButtonFormField<Region>(
                  decoration: const InputDecoration(labelText: 'Регион'),
                  items: const [],
                  onChanged: (Region? value) {},
                  hint: const Text('Загрузка...'),
                ),
                error: (error, stack) => DropdownButtonFormField<Region>(
                  decoration: const InputDecoration(labelText: 'Регион', errorText: 'Ошибка загрузки'),
                  items: [],
                  onChanged: (Region? value) {},
                ),
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
              TextFormField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Широта'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Долгота'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: foundedYearController,
                decoration: const InputDecoration(labelText: 'Год основания'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Телефон'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('Партнер'),
                  const Spacer(),
                  Switch(
                    value: isPartnerController.value,
                    onChanged: (bool newValue) {
                      isPartnerController.value = newValue;
                    },
                  ),
                ],
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
                        regionId: selectedRegion.value?.id,
                        website: websiteController.text,
                        locationText: locationTextController.text,
                        logoUrl: logoUrl, // используем новые URL
                        bannerUrl: bannerUrl, // используем новые URL
                        countryCode: selectedCountry.value?.code,
                        latitude: double.tryParse(latitudeController.text),
                        longitude: double.tryParse(longitudeController.text),
                        foundedYear: int.tryParse(foundedYearController.text),
                        isPartner: isPartnerController.value,
                        phone: phoneController.text,
                        email: emailController.text,
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
                  } catch (e, st) {
                    // Если что-то пошло не так, показываем ошибку
                    debugPrint('Error saving winery: $e');
                    debugPrint('Stack trace: $st');
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
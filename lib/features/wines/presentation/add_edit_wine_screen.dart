import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/services/storage_service.dart';

class AddEditWineScreen extends HookConsumerWidget {
  const AddEditWineScreen({
    super.key,
    required this.wineryId,
    this.wine,
  });

  final String wineryId;
  final Wine? wine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = wine != null;
    
    // Контроллеры для всех полей
    final nameController = useTextEditingController(text: wine?.name);
    final descriptionController = useTextEditingController(text: wine?.description);
    final grapeVarietyController = useTextEditingController(text: wine?.grapeVariety);
    final imageUrlController = useTextEditingController(text: wine?.imageUrl);
    final selectedColor = useState<WineColor?>(wine?.color);
    final selectedType = useState<WineType?>(wine?.type);
    final selectedSugar = useState<WineSugar?>(wine?.sugar);
    final vintageController = useTextEditingController(text: wine?.vintage?.toString() ?? '');
    final alcoholLevelController = useTextEditingController(
      text: wine?.alcoholLevel?.toString(),
    );
    final ratingController = useTextEditingController(
      text: wine?.rating?.toString(),
    );
    final servingTemperatureController = useTextEditingController(
      text: wine?.servingTemperature,
    );

    // Состояния для слайдеров оценок
    final sweetnessValue = useState<int>(wine?.sweetness ?? 1);
    final acidityValue = useState<int>(wine?.acidity ?? 1);
    final tanninsValue = useState<int>(wine?.tannins ?? 1);
    final saturationValue = useState<int>(wine?.saturation ?? 1);

    // GlobalKey для формы
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Локальное состояние для хранения выбранного файла
    final imageFile = useState<XFile?>(null);
    
    // Инициализация изображения при редактировании
    useEffect(() {
      if (wine?.imageUrl != null && wine!.imageUrl!.startsWith('/')) {
        imageFile.value = XFile(wine!.imageUrl!);
      }
      return null;
    }, []); // Пустой список зависимостей, чтобы инициализация произошла только один раз

    // Слушаем изменения в wineMutationProvider
    ref.listen(
      wineMutationProvider,
      (previous, next) {
        if (next.hasError) {
          // TODO: Показать ошибку пользователю
        } else if (next.isLoading == false && previous?.isLoading == true) {
          // Успешно сохранено
          context.pop();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Редактировать вино' : 'Добавить вино'),
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
                decoration: const InputDecoration(labelText: 'Название вина'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Введите название' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: 3,
              ),
              // Виджет превью изображения
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageFile.value != null
                      ? Image.file(File(imageFile.value!.path), fit: BoxFit.contain)
                      : imageUrlController.text.isNotEmpty && Uri.parse(imageUrlController.text).isAbsolute
                          ? Image.network(imageUrlController.text, fit: BoxFit.contain)
                          : const Icon(
                              Icons.image_outlined,
                              size: 80,
                              color: Colors.grey,
                            ),
                ),
              ),
              const SizedBox(height: 16),
              // Кнопка выбора изображения
              TextButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    imageFile.value = pickedFile;
                  }
                },
                child: const Text('Загрузить изображение'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: grapeVarietyController,
                decoration: const InputDecoration(labelText: 'Сорт винограда'),
              ),
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'URL изображения'),
              ),
              DropdownButtonFormField<WineColor>(
                initialValue: selectedColor.value,
                decoration: const InputDecoration(labelText: 'Цвет'),
                items: WineColor.values
                    .where((color) => color != WineColor.unknown)
                    .map((color) {
                  return DropdownMenuItem(
                    value: color,
                    child: Text(color.nameRu),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedColor.value = newValue;
                },
              ),
              DropdownButtonFormField<WineType>(
                initialValue: selectedType.value,
                decoration: const InputDecoration(labelText: 'Тип'),
                items: WineType.values
                    .where((type) => type != WineType.unknown)
                    .map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.nameRu),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedType.value = newValue;
                },
              ),
              DropdownButtonFormField<WineSugar>(
                initialValue: selectedSugar.value,
                decoration: const InputDecoration(labelText: 'Сахар'),
                items: WineSugar.values
                    .where((sugar) => sugar != WineSugar.unknown)
                    .map((sugar) {
                  return DropdownMenuItem(
                    value: sugar,
                    child: Text(sugar.nameRu),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedSugar.value = newValue;
                },
              ),
              TextFormField(
                controller: alcoholLevelController,
                decoration: const InputDecoration(labelText: 'Крепость (%)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return null; // Необязательное поле
                  final strength = double.tryParse(value);
                  if (strength == null || strength < 0 || strength > 100) {
                    return 'Введите корректную крепость';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Рейтинг'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return null; // Необязательное поле
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 0 || rating > 5) {
                    return 'Введите корректный рейтинг (0-5)';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: vintageController,
                decoration: const InputDecoration(labelText: 'Год'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: servingTemperatureController,
                decoration: const InputDecoration(labelText: 'Температура подачи'),
              ),
              // Слайдеры для оценок
              const SizedBox(height: 16),
              Text('Сладость: ${sweetnessValue.value}'),
              Slider(
                value: sweetnessValue.value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4, // 5-1=4
                label: sweetnessValue.value.toString(),
                onChanged: (newValue) {
                  sweetnessValue.value = newValue.round();
                },
              ),
              Text('Кислотность: ${acidityValue.value}'),
              Slider(
                value: acidityValue.value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4, // 5-1=4
                label: acidityValue.value.toString(),
                onChanged: (newValue) {
                  acidityValue.value = newValue.round();
                },
              ),
              Text('Танины: ${tanninsValue.value}'),
              Slider(
                value: tanninsValue.value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4, // 5-1=4
                label: tanninsValue.value.toString(),
                onChanged: (newValue) {
                  tanninsValue.value = newValue.round();
                },
              ),
              Text('Насыщенность: ${saturationValue.value}'),
              Slider(
                value: saturationValue.value.toDouble(),
                min: 1,
                max: 5,
                divisions: 4, // 5-1=4
                label: saturationValue.value.toString(),
                onChanged: (newValue) {
                  saturationValue.value = newValue.round();
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Блокируем кнопку, чтобы избежать двойных нажатий
                  // (если у вас этого еще нет)
                  final mutationState = ref.watch(wineMutationProvider);
                  print('Current Mutation State: $mutationState'); // <-- ДОБАВЬ ЭТУ СТРОКУ
                  if (mutationState.isLoading) return;

                  try {
                    if (formKey.currentState!.validate()) {
                      // Загружаем изображение в Storage, если оно выбрано
                      String? imageUrl;
                      if (imageFile.value != null) {
                        final fileName = await ref.read(storageServiceProvider).uploadFile(
                              'wine_images', // имя бакета
                              imageFile.value!,
                            );
                        // Формируем полный URL здесь
                        imageUrl = Supabase.instance.client.storage
                            .from('wine_images')
                            .getPublicUrl(fileName);
                      } else if (imageUrlController.text.isNotEmpty) {
                        // Если файл не выбран, но URL уже есть, используем его
                        imageUrl = imageUrlController.text;
                      }

                      final wineToSave = Wine(
                        id: isEditMode ? wine!.id : null, // ID будет сгенерирован базой данных
                        wineryId: wineryId,
                        name: nameController.text,
                        description: descriptionController.text.isEmpty ? null : descriptionController.text,
                        grapeVariety: grapeVarietyController.text.isEmpty ? null : grapeVarietyController.text,
                        imageUrl: imageUrl, // Используем URL загруженного изображения
                        color: selectedColor.value,
                        type: selectedType.value,
                        sugar: selectedSugar.value,
                        vintage: int.tryParse(vintageController.text ?? ''),
                        alcoholLevel: alcoholLevelController.text.isEmpty ? null : double.tryParse(alcoholLevelController.text),
                        rating: ratingController.text.isEmpty ? null : double.tryParse(ratingController.text),
                        servingTemperature: servingTemperatureController.text.isEmpty ? null : servingTemperatureController.text,
                        sweetness: sweetnessValue.value,
                        acidity: acidityValue.value,
                        tannins: tanninsValue.value,
                        saturation: saturationValue.value,
                        createdAt: isEditMode ? wine!.createdAt : DateTime.now(),
                        updatedAt: DateTime.now(),
                        isDeleted: false,
                      );

                      print('--- SAVING WINE ---');
                      print(wineToSave.toJson()); // <-- Печатаем весь объект

                      if (isEditMode) {
                        ref.read(wineMutationProvider.notifier).updateWine(wineToSave);
                      } else {
                        ref.read(wineMutationProvider.notifier).addWine(wineToSave);
                      }
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

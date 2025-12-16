// lib/screens/add_wine_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io'; // Для работы с File
import 'package:image_picker/image_picker.dart'; // Для выбора изображения
// Для работы с File
//import 'package:http/http.dart' as http; // Для сетевых запросов
// Предполагаемый сервис для загрузки данных
import 'package:winepool_final/services/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../common/widgets/shimmer_loading_indicator.dart';

class AddWineScreen extends StatefulWidget {
  const AddWineScreen({super.key});

  @override
 State<AddWineScreen> createState() => _AddWineScreenState();
}

class _AddWineScreenState extends State<AddWineScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Контроллеры для полей формы
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Переменная для хранения выбранного файла изображения
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  // --- ЛОГИКА ВЫБОРА ИЗОБРАЖЕНИЯ ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Метод для отображения состояния загрузки
  Widget _buildUploadState(AsyncValue<bool> uploadState) {
    if (uploadState.isLoading) {
      return const Center(child: ShimmerLoadingIndicator());
    } else if (uploadState.hasError) {
      return SelectableText.rich(
        TextSpan(
          text: 'Ошибка: ${uploadState.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить новое вино')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
          builder: (context, ref, child) {
            // Создаем AsyncValue для отслеживания состояния загрузки
            AsyncValue<bool> uploadState = ref.watch(uploadWineProvider);
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // --- 1. ВЫБОР ИЗОБРАЖЕНИЯ ---
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text(
                                'Нажмите, чтобы выбрать фото',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  // --- 2. ПОЛЯ ФОРМЫ ---
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Название вина'),
                    validator: (value) => value!.isEmpty ? 'Введите название' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Цена'),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Введите цену' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Описание'),
                    maxLines: 3,
                    validator: (value) => value!.isEmpty ? 'Введите описание' : null,
                  ),
                  const SizedBox(height: 16.0),
                  
                  // --- ОТОБРАЖЕНИЕ СОСТОЯНИЯ ЗАГРУЗКИ И ОШИБОК ---
                  _buildUploadState(uploadState),
                  
                  const SizedBox(height: 14.0),

                  // --- 3. КНОПКА ОТПРАВКИ ---
                  ElevatedButton.icon(
                    onPressed: uploadState.isLoading ? null : () async {
                      if (!_formKey.currentState!.validate()) {
                        return; // Проверка валидации полей
                      }
                      if (_selectedImage == null) {
                        // Показать ошибку, если изображение не выбрано
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Пожалуйста, выберите изображение вина')),
                          );
                        }
                        return;
                      }

                      // Вызываем асинхронный провайдер для загрузки вина
                      ref.read(uploadWineProvider.notifier).uploadWine(
                        name: _nameController.text,
                        price: double.parse(_priceController.text),
                        description: _descriptionController.text,
                        imageFile: _selectedImage!,
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('СОХРАНИТЬ ВИНО'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// AsyncNotifierProvider для управления состоянием загрузки вина
class UploadWineNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async => false;

  Future<void> uploadWine({
    required String name,
    required double price,
    required String description,
    required File imageFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Имитация вызова сервиса для отправки данных и файла на сервер
      // В реальном приложении здесь будет сложная логика HTTP multipart
      // Загружаем изображение и получаем URL
      final imageUrl = await StorageService(Supabase.instance.client).uploadFile('products', XFile(imageFile.path));
      
      // Имитация отправки остальных данных на сервер
      await Future.delayed(const Duration(seconds: 2));
      print('Имитация: Отправлены данные: $name, $price, $description');
      print('Имитация: Отправлен файл с URL: $imageUrl');

      // Возвращаем true, чтобы показать успешное сохранение
      final success = true;

      if (success) {
        state = const AsyncValue.data(true);
        // Через небольшую задержку возвращаем назад
        await Future.delayed(const Duration(milliseconds: 500));
        // Убираем использование GlobalNavigatorKey, так как он не нужен в AsyncNotifier
        // Вместо этого, обработка будет происходить в UI
      } else {
        state = const AsyncValue.error('Ошибка сохранения данных.', StackTrace.empty);
      }
    } catch (e, stack) {
      state = AsyncValue.error('Ошибка API: $e', stack);
    }
  }
}

final uploadWineProvider = AsyncNotifierProvider<UploadWineNotifier, bool>(
  UploadWineNotifier.new,
);

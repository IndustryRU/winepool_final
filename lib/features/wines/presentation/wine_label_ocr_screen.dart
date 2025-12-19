import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart'; // Импортируем Tesseract OCR
import 'package:winepool_final/services/yandex_ocr_service.dart'; // Импортируем Yandex OCR сервис
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Добавляем hooks_riverpod для FutureProvider
import 'package:winepool_final/features/wines/application/wine_label_search_controller.dart'; // Импортируем новый контроллер
import 'package:winepool_final/features/wines/domain/wine.dart'; // Импортируем модель Wine
import 'package:winepool_final/features/cellar/application/cellar_controller.dart'; // Импортируем контроллер погребка
import 'package:winepool_final/features/wines/presentation/add_edit_wine_screen.dart'; // Импортируем экран добавления/редактирования вина
import 'package:go_router/go_router.dart'; // Импортируем GoRouter для навигации
import 'package:winepool_final/services/wine_label_text_processor.dart'; // Импортируем сервис для обработки текста
import 'package:winepool_final/features/profile/application/ocr_service_controller.dart'; // Импортируем провайдер для выбора OCR-сервиса
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart'; // Импортируем Google ML Kit для распознавания текста
import 'package:image/image.dart' as img; // Импортируем библиотеку для работы с изображениями

class WineLabelOcrScreen extends ConsumerStatefulWidget {
  const WineLabelOcrScreen({super.key});

  @override
  ConsumerState<WineLabelOcrScreen> createState() => _WineLabelOcrScreenState();
}

class _WineLabelOcrScreenState extends ConsumerState<WineLabelOcrScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String _recognizedText = '';
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        requestFullMetadata: true,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _recognizedText = '';
        });
        await _processImageWithOCR(_selectedImage!);
      }
    } catch (e) {
      _showErrorDialog('Ошибка при выборе изображения: $e');
    }
  }

  Future<void> _selectImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _recognizedText = '';
        });
        await _processImageWithOCR(_selectedImage!);
      }
    } catch (e) {
      _showErrorDialog('Ошибка при выборе изображения из галереи: $e');
    }
  }

  Future<void> _processImageWithOCR(File imageFile) async {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Получаем выбранный пользователем OCR-сервис из провайдера
      final ocrService = ref.read(ocrServiceProvider);

      String recognizedText = '';

      if (ocrService == OcrService.tesseract) {
        // Используем Tesseract OCR
        recognizedText = await FlutterTesseractOcr.extractText(
          imageFile.path,
          language: 'rus+eng', // Указываем язык для поддержки кириллицы
          args: {
            //"tessedit_char_whitelist": "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюя .,-",
            //"user_defined_dpi": "300",
            'psm': '11', // 3 автомат, 11 - шум, https://microkontroller.ru/raspberry-pi-projects/opticheskoe-raspoznavanie-simvolov-v-raspberry-pi-s-pomoshhyu-tesseract/
            'oem': '1', //режим работы "движка" распознавания символов 0, 1, 2, 3 (по умолчанию 3)
          },
        );
      } else if (ocrService == OcrService.yandex) {
        // Используем Yandex OCR API
        recognizedText = await YandexOcrService.extractText(imageFile.path); // Вызываем статический метод Yandex OCR
      } else {
        // Используем Google ML Kit (латинский скрипт)
        final inputImage = InputImage.fromFilePath(imageFile.path);
        final textRecognizer = TextRecognizer(
          script: TextRecognitionScript.latin,
        );

        final RecognizedText mlKitRecognizedText = await textRecognizer.processImage(inputImage);
        recognizedText = mlKitRecognizedText.text;

        await textRecognizer.close();
      }

      setState(() {
        _recognizedText = recognizedText.trim();
      });
    } catch (e) {
      _showErrorDialog('Ошибка при распознавании текста: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showErrorDialog(String errorMessage) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // В ConsumerStatefulWidget ref доступен напрямую через this.ref
    final searchResults = ref.watch(wineLabelSearchProvider(_recognizedText)); // Наблюдаем за результатами поиска

    return Scaffold(
      appBar: AppBar(
        title: const Text('Распознавание этикетки вина'),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_selectedImage != null)
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Сделать фото'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _selectImageFromGallery,
                  icon: const Icon(Icons.image),
                  label: const Text('Из галереи'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (_isProcessing)
              const LinearProgressIndicator()
            else
              const SizedBox.shrink(),
            
            const SizedBox(height: 16),
            
            const Text(
              'Распознанный текст:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: SelectableText.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.black87),
                        children: [
                          if (_recognizedText.isNotEmpty)
                            TextSpan(text: _recognizedText)
                          else
                            const TextSpan(
                              text: 'Текст с этикетки будет отображен здесь после распознавания.',
                              style: TextStyle(color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Виджет для отображения результатов поиска и кнопки "Добавить в погребок"
            if (_recognizedText.isNotEmpty && !_isProcessing)
              searchResults.when(
                data: (wines) {
                  if (wines.isEmpty) {
                    // Если вино не найдено, предлагаем добавить новое
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Вино не найдено в базе данных.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Навигация на экран добавления вина
                              // GoRouter.of(context).push('/wines-catalog/add', extra: _recognizedText);
                              // Пока просто покажем SnackBar
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Функция добавления вина из OCR в разработке.')),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Добавить винo'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Если вино найдено, показываем его и кнопку "Добавить в погребок"
                    final foundWine = wines.first; // Берем первое найденное вино
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Найдено вино: ${foundWine.name ?? "Неизвестно"}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                // Добавляем вино в "Храню" с количеством 1
                                await ref.read(cellarControllerProvider.notifier).addToStorage(
                                  wineId: foundWine.id ?? '',
                                  quantity: 1,
                                  // Можно добавить другие поля, если они доступны из распознанного текста
                                );
                                // Инвалидируем провайдер хранилища для обновления UI
                                ref.invalidate(cellarStorageProvider);
                                // Показываем сообщение об успехе
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Вино добавлено в погребок!')),
                                );
                              } catch (e) {
                                // Показываем сообщение об ошибке
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка при добавлении вина: $e')),
                                );
                              }
                            },
                            icon: const Icon(Icons.local_bar),
                            label: const Text('Добавить в Погребок'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                loading: () => const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: SelectableText.rich(
                      TextSpan(
                        text: 'Ошибка поиска: $error',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
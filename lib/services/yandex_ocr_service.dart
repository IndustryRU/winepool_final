import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Импортируем пакет image
import 'package:winepool_final/config/yandex_cloud_config.dart'; // Импортируем конфиг

class YandexOcrService {
  static const String _apiEndpoint = 'https://vision.api.cloud.yandex.net/vision/v1/batchAnalyze';

  /// Извлекает текст из изображения, используя Yandex OCR API.
  ///
  /// [imagePath] - путь к файлу изображения.
  /// Возвращает распознанный текст в виде строки.
  static Future<String> extractText(String imagePath) async {
    try {
      // final iamToken = await YandexCloudAuthService.getIamToken(); // Удаляем
      final imageBytes = await File(imagePath).readAsBytes();

      // --- Начало изменения ---
      // Декодируем изображение
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        debugPrint('Не удалось декодировать изображение: $imagePath');
        return '';
      }

      // Определяем коэффициент масштабирования, чтобы большая сторона была не более 600 пикселей
      int newWidth = originalImage.width;
      int newHeight = originalImage.height;
      const int maxDimension = 600;

      if (originalImage.width > originalImage.height) {
        if (originalImage.width > maxDimension) {
          newWidth = maxDimension;
          newHeight = (originalImage.height * (maxDimension / originalImage.width)).round();
        }
      } else {
        if (originalImage.height > maxDimension) {
          newHeight = maxDimension;
          newWidth = (originalImage.width * (maxDimension / originalImage.height)).round();
        }
      }

      // Изменяем размер изображения
      img.Image resizedImage = img.copyResize(originalImage, width: newWidth, height: newHeight);

      // Кодируем изображение обратно в JPEG с качеством 70
      List<int> resizedImageBytes = img.encodeJpg(resizedImage, quality: 70);

      // Кодируем в base64
      final base64Image = base64Encode(resizedImageBytes);
      // --- Конец изменения ---

      final requestBody = {
        "folderId": YandexCloudConfig.folderId, // Берем из конфига
        "analyze_specs": [
          {
            "content": base64Image,
            "features": [
              {
                "type": "TEXT_DETECTION",
                "textDetectionConfig": {
                  "languageCodes": ["ru", "en"] // Указываем языки для распознавания
                }
              }
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(_apiEndpoint),
        headers: {
          'Authorization': 'Api-Key ${YandexCloudConfig.apiKey}', // Используем API-ключ
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        debugPrint('Yandex OCR API Response: ${jsonEncode(jsonResponse)}'); // Логируем полный ответ
        // Обработка ответа от Yandex Cloud Vision API
        // Извлечение текста из блоков
        String recognizedText = '';
        if (jsonResponse['results'] != null) {
          for (var result in jsonResponse['results']) {
            if (result['results'] != null) {
              for (var featureResult in result['results']) {
                if (featureResult['textDetection'] != null && featureResult['textDetection']['pages'] != null) { // Изменено: textAnnotation -> textDetection
                  for (var page in featureResult['textDetection']['pages']) { // Изменено: textAnnotation -> textDetection
                    if (page['blocks'] != null) {
                      for (var block in page['blocks']) {
                        if (block['lines'] != null) {
                          for (var line in block['lines']) {
                            if (line['words'] != null) {
                              for (var word in line['words']) {
                                recognizedText += word['text'] + ' '; // Добавляем пробел между словами
                              }
                              recognizedText += '\n'; // Переход на новую строку после линии
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
        return recognizedText.trim();
      } else {
        // Логируем ошибку и возвращаем пустую строку
        debugPrint('Yandex OCR API error: ${response.statusCode} - ${response.body}');
        return '';
      }
    } catch (e) {
      // Логируем ошибку и возвращаем пустую строку
      debugPrint('Ошибка при распознавании текста с помощью Yandex OCR: $e');
      return '';
    }
  }
}
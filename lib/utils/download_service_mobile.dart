import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadServiceMobile {
  static Future<String?> downloadFile(Uint8List bytes, String filename) async {
    try {
      // Запрашиваем разрешение на доступ к внешнему хранилищу
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        debugPrint('Разрешение на доступ к хранилищу не получено');
        return null;
      }

      // Получаем директорию для сохранения файлов
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        debugPrint('Не удалось получить директорию для сохранения файлов');
        return null;
      }

      // Создаем путь к файлу
      final filePath = '${directory.path}/$filename';
      final file = File(filePath);

      // Записываем байты в файл
      await file.writeAsBytes(bytes);

      // Проверяем, существует ли файл
      if (await file.exists()) {
        debugPrint('Файл успешно сохранен: $filePath');
        return filePath;
      } else {
        debugPrint('Не удалось создать файл: $filePath');
        return null;
      }
    } catch (e) {
      debugPrint('Ошибка при сохранении файла: $e');
      return null;
    }
  }
}

// Экспортируем функцию для использования с импортом как в import_data_screen
Future<String?> downloadFile(Uint8List bytes, String filename) async {
  return await DownloadServiceMobile.downloadFile(bytes, filename);
}
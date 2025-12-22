import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> downloadFile(List<int> bytes, String fileName) async {
  if (await Permission.storage.request().isGranted) {
    try {
      final downloadsDir = '/storage/emulated/0/Download'; // Стандартный путь
      final filePath = '$downloadsDir/$fileName';
      
      // Dio не нужен для сохранения байтов, используем File
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Показываем уведомление
      print('Файл успешно сохранен: $filePath');
      return filePath;
    } catch (e) {
      print('Ошибка при сохранении файла: $e');
      return null;
    }
  } else {
    throw Exception('Разрешение на запись в хранилище не получено');
  }
}
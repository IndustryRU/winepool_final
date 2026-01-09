import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';
import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart' show rootBundle;

class ImportResult {
 final int totalRows;
  final int successCount;
  final int errorCount;
  final List<String> errorDetails;

  ImportResult({
    required this.totalRows,
    required this.successCount,
    required this.errorCount,
    required this.errorDetails,
  });

  bool get hasErrors => errorCount > 0;
  double get successPercentage => totalRows > 0 ? (successCount / totalRows) * 100 : 0;
}

class DataImportService {
  final Ref _ref;
  final Uuid _uuid = const Uuid();

  DataImportService(this._ref);

  /// Импорт виноделен из CSV-файла
  Future<ImportResult> importWineries(
      Stream<List<int>> fileStream, 
      ValueNotifier<double> progressNotifier, 
      WidgetRef ref
    ) async {
    try {
      // Читаем весь CSV-файл в строку
      final bytes = await fileStream.toBytes();
      final csvContent = utf8.decode(bytes);
      final parsedCsv = const CsvToListConverter().convert(csvContent);
      
      // Проверяем заголовки
      if (parsedCsv.isEmpty) {
        return ImportResult(
          totalRows: 0,
          successCount: 0,
          errorCount: 0,
          errorDetails: ['CSV файл пуст'],
        );
      }
      
      final headers = parsedCsv[0].cast<String>();
      final requiredHeaders = ['name'];
      for (final header in requiredHeaders) {
        if (!headers.contains(header)) {
          return ImportResult(
            totalRows: 0,
            successCount: 0,
            errorCount: 1,
            errorDetails: ['Отсутствует обязательное поле: $header'],
          );
        }
      }

      final dataRows = parsedCsv.skip(1).toList();
      int importedCount = 0;
      int errorCount = 0;
      List<String> errors = [];
      final totalRows = dataRows.length;

      for (int i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        try {
          final Map<String, dynamic> wineryData = {};
          
          for (int j = 0; j < headers.length; j++) {
            final header = headers[j];
            final value = row[j]?.toString()?.trim();
            
            if (value != null && value.isNotEmpty) {
              switch (header.toLowerCase()) {
                case 'id':
                  wineryData['id'] = value;
                  break;
                case 'name':
                  wineryData['name'] = value;
                  break;
                case 'country_code':
                  // Мы обработаем это поле позже, после получения supabaseClient
                  break;
                case 'description':
                  wineryData['description'] = value;
                  break;
              }
            }
          }

          // Проверяем обязательные поля
          if (wineryData['name']?.isEmpty ?? true) {
            throw Exception('Поле name обязательно для заполнения');
          }

          // Получаем клиент Supabase
          final supabaseClient = _ref.read(supabaseClientProvider);

          // Получаем country_id по country_code
          final countryCode = row[headers.indexOf('country_code')]?.toString()?.trim();
          if (countryCode != null && countryCode.isNotEmpty) {
            final countryResult = await supabaseClient
                .from('countries')
                .select('id')
                .eq('code', countryCode.toUpperCase())
                .limit(1);

            if (countryResult.isNotEmpty) {
              wineryData['country_id'] = countryResult.first['id'];
            } else {
              errors.add('Строка ${i + 2}: Код страны "$countryCode" не найден.');
            }
          }

          // Если id не был предоставлен в CSV, генерируем новый
          if (wineryData['id'] == null || wineryData['id'].toString().isEmpty) {
            wineryData['id'] = _uuid.v4();
          }

          // Выполняем upsert
          await supabaseClient
              .from('wineries')
              .upsert(wineryData);

          importedCount++;
        } catch (e) {
          errorCount++;
          errors.add('Строка ${i + 2}: ${e.toString()}'); // +2 потому что первая строка это заголовки
        }

        // Обновляем прогресс
        progressNotifier.value = (i + 1) / totalRows;
      }

      return ImportResult(
        totalRows: totalRows,
        successCount: importedCount,
        errorCount: errorCount,
        errorDetails: errors,
      );
    } catch (e) {
      return ImportResult(
        totalRows: 0,
        successCount: 0,
        errorCount: 1,
        errorDetails: ['Ошибка при парсинге CSV: ${e.toString()}'],
      );
    }
  }

  /// Импорт вин из CSV-файла
  Future<ImportResult> importWines(
    Stream<List<int>> fileStream, 
    ValueNotifier<double> progressNotifier, 
    WidgetRef ref
  ) async {
    try {
      // Читаем весь CSV-файл в строку
      final bytes = await fileStream.toBytes();
      final csvContent = utf8.decode(bytes);
      final parsedCsv = const CsvToListConverter().convert(csvContent);
      
      // Проверяем заголовки
      if (parsedCsv.isEmpty) {
        return ImportResult(
          totalRows: 0,
          successCount: 0,
          errorCount: 0,
          errorDetails: ['CSV файл пуст'],
        );
      }
      
      final headers = parsedCsv[0].cast<String>();
      final requiredHeaders = ['name', 'winery_name'];
      for (final header in requiredHeaders) {
        if (!headers.contains(header)) {
          return ImportResult(
            totalRows: 0,
            successCount: 0,
            errorCount: 1,
            errorDetails: ['Отсутствует обязательное поле: $header'],
          );
        }
      }

      final dataRows = parsedCsv.skip(1).toList();
      int importedCount = 0;
      int errorCount = 0;
      List<String> errors = [];
      final totalRows = dataRows.length;

      for (int i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        try {
          final Map<String, dynamic> wineData = {};
          String? wineryName;
          
          for (int j = 0; j < headers.length; j++) {
            final header = headers[j];
            final value = row[j]?.toString()?.trim();
            
            switch (header.toLowerCase()) {
              case 'name':
                wineData['name'] = value;
                break;
              case 'winery_name':
                wineryName = value;
                break;
              // Удаляем обработку поля vintage, так как оно больше не используется в модели Wine
              case 'grape_variety':
                if (value != null && value.isNotEmpty) {
                  wineData['grape_variety'] = value;
                }
                break;
              case 'color':
                if (value != null && value.isNotEmpty) {
                  wineData['color'] = value;
                }
                break;
              case 'sugar':
                if (value != null && value.isNotEmpty) {
                  wineData['sugar'] = value;
                }
                break;
              case 'alcohol_level':
                if (value != null && value.isNotEmpty) {
                  wineData['alcohol_level'] = double.tryParse(value);
                }
                break;
              case 'image_url':
                if (value != null && value.isNotEmpty) {
                  wineData['image_url'] = value;
                }
                break;
            }
          }

          // Проверяем обязательные поля
          if (wineData['name']?.isEmpty ?? true) {
            throw Exception('Поле name обязательно для заполнения');
          }
          if (wineryName?.isEmpty ?? true) {
            throw Exception('Поле winery_name обязательно для заполнения');
          }

          // Получаем клиент Supabase
          final supabaseClient = _ref.read(supabaseClientProvider);

          // Находим ID винодельни по имени
          final wineryResult = await supabaseClient
              .from('wineries')
              .select('id')
              .eq('name', wineryName!)
              .limit(1);
              
          if (wineryResult.isEmpty) {
            throw Exception('Винодельня с названием "$wineryName" не найдена');
          }
          
          final wineryId = wineryResult.first['id'];
          wineData['winery_id'] = wineryId;

          // Генерируем уникальный ID для вина
          wineData['id'] = _uuid.v4();

          // Вставляем данные о вине
          await supabaseClient.from('wines').insert(wineData);

          importedCount++;
        } catch (e) {
          errorCount++;
          errors.add('Строка ${i + 2}: ${e.toString()}'); // +2 потому что первая строка это заголовки
        }

        // Обновляем прогресс
        progressNotifier.value = (i + 1) / totalRows;
      }

      return ImportResult(
        totalRows: totalRows,
        successCount: importedCount,
        errorCount: errorCount,
        errorDetails: errors,
      );
    } catch (e) {
      return ImportResult(
        totalRows: 0,
        successCount: 0,
        errorCount: 1,
        errorDetails: ['Ошибка при парсинге CSV: ${e.toString()}'],
      );
    }
  }

 /// Импорт сортов винограда из CSV-файла
  Future<ImportResult> importGrapeVarieties(
    Stream<List<int>> fileStream, 
    ValueNotifier<double> progressNotifier, 
    WidgetRef ref
  ) async {
    try {
      // Читаем весь CSV-файл в строку
      final bytes = await fileStream.toBytes();
      final csvContent = utf8.decode(bytes);
      final parsedCsv = const CsvToListConverter().convert(csvContent);
      
      // Проверяем заголовки
      if (parsedCsv.isEmpty) {
        return ImportResult(
          totalRows: 0,
          successCount: 0,
          errorCount: 0,
          errorDetails: ['CSV файл пуст'],
        );
      }
      
      final headers = parsedCsv[0].cast<String>();
      final requiredHeaders = ['name'];
      for (final header in requiredHeaders) {
        if (!headers.contains(header)) {
          return ImportResult(
            totalRows: 0,
            successCount: 0,
            errorCount: 1,
            errorDetails: ['Отсутствует обязательное поле: $header'],
          );
        }
      }

      final dataRows = parsedCsv.skip(1).toList();
      int importedCount = 0;
      int errorCount = 0;
      List<String> errors = [];
      final totalRows = dataRows.length;

      for (int i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        try {
          final Map<String, dynamic> grapeData = {};
          
          for (int j = 0; j < headers.length; j++) {
            final header = headers[j];
            final value = row[j]?.toString()?.trim();
            
            if (value != null && value.isNotEmpty) {
              switch (header.toLowerCase()) {
                case 'id':
                  grapeData['id'] = value;
                  break;
                case 'name':
                  grapeData['name'] = value;
                  break;
                case 'description':
                  grapeData['description'] = value;
                  break;
                case 'origin_region':
                  grapeData['origin_region'] = value;
                  break;
              }
            } else if (header == 'id' && (grapeData['id'] == null || grapeData['id'].isEmpty)) {
              // Генерируем UUID если id не указан
              grapeData['id'] = _uuid.v4();
            }
          }

          // Проверяем обязательные поля
          if (grapeData['name']?.isEmpty ?? true) {
            throw Exception('Поле name обязательно для заполнения');
          }

          // Получаем клиент Supabase
          final supabaseClient = _ref.read(supabaseClientProvider);

          // Выполняем upsert
          await supabaseClient
              .from('grape_varieties')
              .upsert(grapeData)
              .match({'id': grapeData['id']});

          importedCount++;
        } catch (e) {
          errorCount++;
          errors.add('Строка ${i + 2}: ${e.toString()}'); // +2 потому что первая строка это заголовки
        }

        // Обновляем прогресс
        progressNotifier.value = (i + 1) / totalRows;
      }

      return ImportResult(
        totalRows: totalRows,
        successCount: importedCount,
        errorCount: errorCount,
        errorDetails: errors,
      );
    } catch (e) {
      return ImportResult(
        totalRows: 0,
        successCount: 0,
        errorCount: 1,
        errorDetails: ['Ошибка при парсинге CSV: ${e.toString()}'],
      );
    }
  }

  /// Импорт сортов винограда из встроенного CSV-файла
  Future<ImportResult> importGrapeVarietiesFromAsset() async {
    try {
      // Читаем содержимое CSV-файла из ресурсов
      final csvContent = await rootBundle.loadString('assets/csv_templates/grape_varieties_full.csv');
      final parsedCsv = const CsvToListConverter().convert(csvContent);
      
      // Проверяем заголовки
      if (parsedCsv.isEmpty) {
        return ImportResult(
          totalRows: 0,
          successCount: 0,
          errorCount: 0,
          errorDetails: ['CSV файл пуст'],
        );
      }
      
      final headers = parsedCsv[0].cast<String>();
      final requiredHeaders = ['name'];
      for (final header in requiredHeaders) {
        if (!headers.contains(header)) {
          return ImportResult(
            totalRows: 0,
            successCount: 0,
            errorCount: 1,
            errorDetails: ['Отсутствует обязательное поле: $header'],
          );
        }
      }

      final dataRows = parsedCsv.skip(1).toList();
      int importedCount = 0;
      int errorCount = 0;
      List<String> errors = [];
      final totalRows = dataRows.length;

      // Создаем список для хранения данных сортов винограда для upsert
      final List<Map<String, dynamic>> grapeVarietiesToInsert = [];

      for (int i = 0; i < dataRows.length; i++) {
        final row = dataRows[i];
        try {
          final Map<String, dynamic> grapeData = {};
          
          for (int j = 0; j < headers.length; j++) {
            final header = headers[j];
            final value = row[j]?.toString()?.trim();
            
            if (value != null && value.isNotEmpty) {
              switch (header.toLowerCase()) {
                case 'id':
                  grapeData['id'] = value;
                  break;
                case 'name':
                  grapeData['name'] = value;
                  break;
                case 'description':
                  grapeData['description'] = value;
                  break;
                case 'origin_region':
                  grapeData['origin_region'] = value;
                  break;
              }
            } else if (header == 'id' && (grapeData['id'] == null || grapeData['id'].isEmpty)) {
              // Генерируем UUID если id не указан
              grapeData['id'] = _uuid.v4();
            }
          }

          // Проверяем обязательные поля
          if (grapeData['name']?.isEmpty ?? true) {
            throw Exception('Поле name обязательно для заполнения');
          }

          // Добавляем подготовленные данные в список для upsert
          grapeVarietiesToInsert.add(grapeData);
        } catch (e) {
          errorCount++;
          errors.add('Строка ${i + 2}: ${e.toString()}'); // +2 потому что первая строка это заголовки
        }
      }

      // Добавляем отладочный вывод перед вызовом upsert
      log('Data to upsert: $grapeVarietiesToInsert');

      // Выполняем upsert всех данных за один вызов
      if (grapeVarietiesToInsert.isNotEmpty) {
        // Получаем клиент Supabase
        final supabaseClient = _ref.read(supabaseClientProvider);

        await supabaseClient
            .from('grape_varieties')
            .upsert(
              grapeVarietiesToInsert,
              onConflict: 'name', // Указываем, что 'name' - это колонка для проверки конфликта
            );
      }

      return ImportResult(
        totalRows: totalRows,
        successCount: grapeVarietiesToInsert.length,
        errorCount: errorCount,
        errorDetails: errors,
      );
    } catch (e) {
      return ImportResult(
        totalRows: 0,
        successCount: 0,
        errorCount: 1,
        errorDetails: ['Ошибка при чтении или парсинге CSV: ${e.toString()}'],
      );
    }
  }
}

// Расширение для преобразования Stream<List<int>> в Bytes
extension StreamExt on Stream<List<int>> {
  Future<Uint8List> toBytes() async {
    final completer = Completer<Uint8List>();
    final buffers = <List<int>>[];

    listen(
      (buffer) => buffers.add(buffer),
      onError: completer.completeError,
      onDone: () => completer.complete(Uint8List.fromList(buffers.expand((e) => e).toList())),
    );

    return completer.future;
  }
}

final dataImportServiceProvider = Provider((ref) => DataImportService(ref));
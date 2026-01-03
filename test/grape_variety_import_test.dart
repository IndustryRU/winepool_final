import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/services/data_import_service.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'grape_variety_import_test.mocks.dart';

@GenerateMocks([SupabaseClient, SupabaseQueryBuilder, PostgrestFilterBuilder])
void main() {
 group('DataImportService Grape Variety Import Tests', () {
    test('importGrapeVarietiesFromAsset should parse and return correct result', () async {
      // Создаем моки
      final mockSupabaseClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final mockFilterBuilder = MockPostgrestFilterBuilder();
      
      // Настраиваем моки
      when(mockSupabaseClient.from(any)).thenAnswer((invocation) => mockQueryBuilder);
      when(mockQueryBuilder.upsert(any)).thenAnswer((invocation) => mockFilterBuilder);
      
      // Создаем контейнер с переопределением провайдера
      final container = ProviderContainer(
        overrides: [
          supabaseClientProvider.overrideWithValue(mockSupabaseClient),
        ],
      );
      
      try {
        // Получаем экземпляр сервиса из провайдера
        final dataImportService = container.read(dataImportServiceProvider);
        
        // Тестируем логику парсинга и формирования результата
        // без фактического подключения к Supabase
        final result = await dataImportService.importGrapeVarietiesFromAsset();
        
        // Проверяем, что результат не null
        expect(result, isNotNull);
        
        // Проверяем, что в файле содержатся сорта винограда
        expect(result.totalRows, greaterThan(0));
        
        // Проверяем, что ошибок нет (предполагаем, что файл корректный)
        expect(result.errorCount, 0);
        
        // Проверяем, что в upsert были переданы корректные данные
        final captured = verify(mockQueryBuilder.upsert(captureAny)).captured;
        expect(captured.first, isA<List<Map<String, dynamic>>>());
        expect(captured.first, isNotEmpty);
        expect(captured.first.first['name'], 'Каберне Совиньон');
        
        // Удаляем отладочные print() сообщения
      } finally {
        container.dispose();
      }
    });
  });
}
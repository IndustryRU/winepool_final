import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:csv/csv.dart';

void main() {
  group('CSV Parsing Tests', () {
    test('should parse grape varieties CSV correctly', () {
      // CSV-данные сортов винограда для тестирования
      const csvContent = '''"name","description","origin_region"
"Каберне Совиньон","Один из самых известных красных сортов винограда в мире","Франция"
"Шардоне","Универсальный белый сорт","Франция"''';
      
      final parsedCsv = const CsvToListConverter().convert(csvContent);
      
      // Проверяем, что CSV успешно распарсен
      expect(parsedCsv.length, 3); // 1 строка заголовков + 2 строки данных
      
      // Проверяем заголовки
      expect(parsedCsv[0], ['name', 'description', 'origin_region']);
      
      // Проверяем первую строку данных
      expect(parsedCsv[1][0], 'Каберне Совиньон');
      expect(parsedCsv[1][1], 'Один из самых известных красных сортов винограда в мире');
      expect(parsedCsv[1][2], 'Франция');
      
      // Проверяем вторую строку данных
      expect(parsedCsv[2][0], 'Шардоне');
      expect(parsedCsv[2][1], 'Универсальный белый сорт');
      expect(parsedCsv[2][2], 'Франция');
    });

    test('should handle grape varieties CSV with real data', () {
      // Проверяем структуру реального файла
      const realCsvContent = '''"name","description","origin_region"
"Каберне Совиньон","Один из самых известных красных сортов винограда в мире. Вина из него получаются насыщенными, с ароматами черной смородины, вишни и нотками кедра.","Бордо, Франция"
"Пино Нуар","Элегантный и ароматный красный сорт, дающий вина с нежным вкусом и ароматами красных ягод, вишни и специй.","Бургундия, Франция"
"Шираз","Мощный и насыщенный сорт, производящий вина с интенсивными фруктовыми нотами и перечным послевкусием.","Рона, Франция"''';
      
      final parsedCsv = const CsvToListConverter().convert(realCsvContent);
      
      // Проверяем, что CSV успешно распарсен
      expect(parsedCsv.length, 4); // 1 строка заголовков + 3 строки данных
      
      // Проверяем заголовки
      expect(parsedCsv[0], ['name', 'description', 'origin_region']);
      
      // Проверяем первую строку данных
      expect(parsedCsv[1][0], 'Каберне Совиньон');
      expect(parsedCsv[1][1], 'Один из самых известных красных сортов винограда в мире. Вина из него получаются насыщенными, с ароматами черной смородины, вишни и нотками кедра.');
      expect(parsedCsv[1][2], 'Бордо, Франция');
      
      // Проверяем третью строку данных
      expect(parsedCsv[3][0], 'Шираз');
      expect(parsedCsv[3][1], 'Мощный и насыщенный сорт, производящий вина с интенсивными фруктовыми нотами и перечным послевкусием.');
      expect(parsedCsv[3][2], 'Рона, Франция');
    });
  });
}
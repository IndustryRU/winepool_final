import 'package:flutter_test/flutter_test.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/services/wine_label_text_processor.dart';

void main() {
  late WineLabelTextProcessor processor;

  setUp(() {
    processor = WineLabelTextProcessor();
  });

  group('WineLabelTextProcessor - processText', () {
    test('Тест на нормализацию', () {
      final result = processor.processText('вино красн. сух.');
      expect(result.color, WineColor.red);
      expect(result.sugar, WineSugar.dry);
    });

    test('Тест на извлечение известного имени', () {
      final result = processor.processText('вино Chateau Margaux premier grand cru classe');
      expect(result.name, 'chateau margaux');
    });

    test('Тест на извлечение алкоголя', () {
      final result = processor.processText('Алк. 12.5% об.');
      expect(result.alcoholLevel, 12.5);
    });

    test('Тест на извлечение года', () {
      final result = processor.processText('Урожай 2020 года');
      expect(result.vintage, 2020);
    });

    test('Тест на извлечение названия в кавычках с сохранением регистра', () {
      final result = processor.processText('Вино «Черный полковник»');
      expect(result.name, 'Черный полковник');
    });

    test('Тест на граничные случаи - пустая строка', () {
      final result = processor.processText('');
      expect(result.name, null);
      expect(result.winery, null);
      expect(result.color, null);
      expect(result.sugar, null);
      expect(result.alcoholLevel, null);
      expect(result.grapeVariety, null);
      expect(result.vintage, null);
    });

    test('Тест на граничные случаи - строка из спецсимволов', () {
      final result = processor.processText('!@#\$%^&*()');
      expect(result.name, null);
      expect(result.winery, null);
      expect(result.color, null);
      expect(result.sugar, null);
      expect(result.alcoholLevel, null);
      expect(result.grapeVariety, null);
      expect(result.vintage, null);
    });

    test('Тест на граничные случаи - очень длинный текст', () {
      final longText = 'Это очень длинный текст с кучей мусора и неинформативными словами ' * 100;
      final result = processor.processText(longText);
      // Ожидаем, что обработка не упадет и вернет пустой WineLabelData
      expect(result.name, null);
      expect(result.winery, null);
      expect(result.color, null);
      expect(result.sugar, null);
      expect(result.alcoholLevel, null);
      expect(result.grapeVariety, null);
      expect(result.vintage, null);
    });

    test('Тест на извлечение цвета на английском', () {
      final result = processor.processText('Red wine');
      expect(result.color, WineColor.red);
    });

    test('Тест на извлечение сахара на английском', () {
      final result = processor.processText('Sweet wine');
      expect(result.sugar, WineSugar.sweet);
    });

    test('Тест на извлечение сорта винограда по ключевому слову', () {
      final result = processor.processText('Сорт винограда Каберне Совиньон');
      expect(result.grapeVariety, 'каберне совиньон');
    });

    test('Тест на извлечение алкоголя в формате XX.X%', () {
      final result = processor.processText('Алкоголь 14.5% об.');
      expect(result.alcoholLevel, 14.5);
    });

    test('Тест на извлечение года с ключевым словом vintage', () {
      final result = processor.processText('Vintage 2018');
      expect(result.vintage, 2018);
    });

    test('Тест на извлечение года без ключевого слова', () {
      final result = processor.processText('Это вино 2019 года');
      expect(result.vintage, 2019);
    });

    test('Тест на извлечение нескольких сущностей одновременно', () {
      final result = processor.processText('Chateau Margaux 2018, красное сухое, 13.5%');
      expect(result.name, 'chateau margaux'); // Теперь извлекается из "базы"
      expect(result.winery, null);
      expect(result.vintage, 2018);
      expect(result.color, WineColor.red);
      expect(result.sugar, WineSugar.dry);
      expect(result.alcoholLevel, 13.5);
    });

    test('Тест на извлечение сорта винограда из базы', () {
      final result = processor.processText('вино chardonnay');
      expect(result.grapeVariety, 'chardonnay');
    });
  });
}
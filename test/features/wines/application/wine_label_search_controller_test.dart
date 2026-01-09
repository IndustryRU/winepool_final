import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:winepool_final/features/wines/application/wine_label_search_controller.dart';
import 'package:winepool_final/features/wines/data/wines_repository.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

import 'wine_label_search_controller_test.mocks.dart';

@GenerateMocks([WinesRepository])
void main() {
  late MockWinesRepository mockWinesRepository;
  late ProviderContainer container;

  setUp(() {
    mockWinesRepository = MockWinesRepository();
    container = ProviderContainer(
      overrides: [
        winesRepositoryProvider.overrideWithValue(mockWinesRepository),
      ],
    );
    // Мокаем все возможные вызовы, чтобы избежать ошибок
    when(mockWinesRepository.searchWines(any)).thenAnswer((_) async => []);
    when(mockWinesRepository.searchAll(any)).thenAnswer((_) async => {'wines': []});
  });

  tearDown(() {
    container.dispose();
  });

  group('wineLabelSearchProvider integration tests', () {
    test('Тест на точный поиск по названию в кавычках', () async {
      // Подготовка данных
      final expectedWine = Wine(id: '1', name: 'Черный полковник', winery: Winery(id: '1', name: 'Солнечная Долина'), color: WineColor.red, sugar: WineSugar.sweet, createdAt: DateTime.now(), updatedAt: DateTime.now(), isDeleted: false);

      // Мокаем поведение репозитория. _multiStageSearch сначала ищет по имени.
      when(mockWinesRepository.searchWines('Черный полковник')).thenAnswer((_) async => [expectedWine]);

      // Вызов провайдера
      final result = await container.read(wineLabelSearchProvider('Вино «Черный полковник» 2020').future);

      // Проверка
      expect(result, isNotEmpty);
      expect(result.first.id, expectedWine.id);
      verify(mockWinesRepository.searchWines('Черный полковник')).called(1);
    });

    test('Тест на поиск по известному имени (из "базы")', () async {
      // Подготовка данных
      final expectedWine = Wine(id: '2', name: 'Chateau Margaux', winery: Winery(id: '2', name: 'Chateau Margaux'), color: WineColor.red, sugar: WineSugar.dry, createdAt: DateTime.now(), updatedAt: DateTime.now(), isDeleted: false);
      
      // Мокаем. processText найдет 'chateau margaux' и передаст его в searchWines
      when(mockWinesRepository.searchWines('chateau margaux')).thenAnswer((_) async => [expectedWine]);

      // Вызов
      final result = await container.read(wineLabelSearchProvider('вино Chateau Margaux premier grand cru classe').future);

      // Проверка
      expect(result, isNotEmpty);
      expect(result.first.id, expectedWine.id);
      verify(mockWinesRepository.searchWines('chateau margaux')).called(1);
    });

    test('Тест на ранжирование по характеристикам', () async {
      // Подготовка данных
      final wine1 = Wine(id: '1', name: 'Идеальное Мерло', winery: Winery(id: '1', name: 'Винодельня 1'), color: WineColor.red, sugar: WineSugar.dry, averageRating: 4.0, createdAt: DateTime.now(), updatedAt: DateTime.now(), isDeleted: false);
      final wine2 = Wine(id: '2', name: 'Просто Мерло', winery: Winery(id: '2', name: 'Винодельня 2'), color: WineColor.red, sugar: WineSugar.semiSweet, averageRating: 4.2, createdAt: DateTime.now(), updatedAt: DateTime.now(), isDeleted: false);

      // Мокаем searchAll, т.к. точного имени нет, поиск пойдет по характеристикам
      when(mockWinesRepository.searchAll(any)).thenAnswer((_) async => {'wines': [wine1.toJson(), wine2.toJson()]});

      // Вызов
      final result = await container.read(wineLabelSearchProvider('Красное сухое Мерло').future);

      // Проверка - wine1 должен быть первым, так как у него больше совпадений
      expect(result, isNotEmpty);
      expect(result.first.id, wine1.id);
    });

    test('Тест на пустой результат', () async {
      // Моки уже настроены в setUp на возврат пустых списков

      // Вызов
      final result = await container.read(wineLabelSearchProvider('абвгд nonexistent wine').future);

      // Проверка
      expect(result, isEmpty);
    });
  });
}
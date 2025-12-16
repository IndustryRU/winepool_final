# Спецификация: Шиммер-эффект для экрана загрузки

## Обзор
Замена стандартного `CircularProgressIndicator` на стильный шиммер-эффект с логотипом приложения для улучшения пользовательского опыта.

## Добавление зависимости
Добавить пакет `shimmer` в файл `pubspec.yaml`:
```yaml
dependencies:
  shimmer: ^3.0.0
```

После добавления выполнить `flutter pub get` для установки пакета.

## Создание виджета ShimmerLoadingIndicator

### Файл: `lib/shared/widgets/shimmer_loading_indicator.dart`
Создать новый переиспользуемый виджет `ShimmerLoadingIndicator`.

#### Структура виджета:
```dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingIndicator extends StatelessWidget {
  const ShimmerLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Image.asset(
        'assets/images/WP_Logo1.png',
        width: 200,
        height: 200,
      ),
    );
  }
}
```

#### Параметры Shimmer.fromColors:
- `baseColor`: `Colors.grey[300]` - базовый цвет для эффекта шиммера
- `highlightColor`: `Colors.grey[100]` - цвет блика для создания переливающегося эффекта
- `child`: `Image.asset('assets/images/WP_Logo1.png')` с фиксированным размером `width: 200, height: 200`

## Интеграция в приложение

### Поиск мест использования
Найти все места в кодовой базе, где используется `CircularProgressIndicator` или аналогичные виджеты для индикации загрузки:
- `SplashScreen` - экран приветствия
- `BuyerHomeScreen` - домашний экран покупателя во время подгрузки данных
- Другие экраны с асинхронной загрузкой данных

### Замена виджетов
Заменить существующие индикаторы загрузки на новый виджет:
```dart
// Было:
Center(child: CircularProgressIndicator())

// Стало:
const ShimmerLoadingIndicator()
```

### Примеры интеграции:
1. В `SplashScreen`: Заменить индикатор в центре экрана
2. В `BuyerHomeScreen`: Использовать при загрузке списка вин
3. В других экранах: Применить аналогично для всех состояний загрузки

## Тестирование
- Проверить корректность отображения шиммер-эффекта на разных устройствах
- Убедиться, что логотип четко виден и эффект плавный
- Проверить производительность при многократном использовании

## Следующие шаги
После создания спецификации перейти в режим Code для реализации описанных изменений.
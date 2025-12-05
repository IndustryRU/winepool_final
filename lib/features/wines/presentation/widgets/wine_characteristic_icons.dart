import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

/// Виджет для отображения пиктограммы цвета вина
class WineColorIcon extends StatelessWidget {
  final WineColor? color;
  final double size;

  const WineColorIcon({
    super.key,
    this.color,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return const SizedBox.shrink();
    }

    Color iconColor;
    switch (color) {
      case WineColor.red:
        iconColor = Colors.red;
      case WineColor.white:
        iconColor = Colors.white;
      case WineColor.rose:
        iconColor = Colors.pink;
      case WineColor.unknown:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor,
        shape: BoxShape.circle,
        border: color == WineColor.white
            ? Border.all(color: Colors.grey, width: 1.0)
            : null,
      ),
    );
  }
}

/// Виджет для отображения пиктограммы содержания сахара вине
class WineSugarIcon extends StatelessWidget {
  final WineSugar? sugar;
  final double size;

  const WineSugarIcon({
    super.key,
    this.sugar,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (sugar == null) {
      return const SizedBox.shrink();
    }

    int filledSegments;
    switch (sugar) {
      case WineSugar.dry:
        filledSegments = 1;
      case WineSugar.semiDry:
        filledSegments = 2;
      case WineSugar.semiSweet:
        filledSegments = 3;
      case WineSugar.sweet:
        filledSegments = 4;
      case WineSugar.unknown:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      width: size / 2,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(
          4,
              (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                color: index < filledSegments ? Colors.orange : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ).reversed.toList(), // Чтобы заполнение шло снизу
      ),
    );
  }
}

/// Виджет для отображения пиктограммы крепости вина
class WineAlcoholIcon extends StatelessWidget {
  final double? alcoholLevel;
  final double size;

  const WineAlcoholIcon({
    super.key,
    this.alcoholLevel,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (alcoholLevel == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.brown.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_drink,
            size: size * 0.6,
            color: Colors.brown,
          ),
          const SizedBox(width: 2),
          Text(
            '${alcoholLevel!.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: size * 0.52, // Увеличено на 30%
              fontWeight: FontWeight.w500,
              color: Colors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет для отображения пиктограммы страны производства
class WineCountryIcon extends StatelessWidget {
  final String? country;
  final double size;

  const WineCountryIcon({
    super.key,
    this.country,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (country == null || country!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Пока просто отображаем текст страны, в будущем можно добавить флаги
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Text(
        country!,
        style: TextStyle(
          fontSize: size * 0.52, // Увеличено на 30%
          fontWeight: FontWeight.w500,
          color: Colors.blue,
        ),
      ),
    );
  }
}

/// Виджет для отображения пиктограммы сорта винограда
class WineGrapeIcon extends StatelessWidget {
  final String? grapeVariety;
  final double size;

  const WineGrapeIcon({
    super.key,
    this.grapeVariety,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    if (grapeVariety == null || grapeVariety!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.grain,
            size: size * 0.6,
            color: Colors.green,
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              grapeVariety!,
              style: TextStyle(
                fontSize: size * 0.52, // Увеличено на 30%
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет для отображения всех пиктограмм характеристик вина
class WineCharacteristicIconsRow extends StatelessWidget {
  final Wine wine;
  final double iconSize;

  const WineCharacteristicIconsRow({
    super.key,
    required this.wine,
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 0,
      children: [
        WineColorIcon(color: wine.color, size: iconSize),
        WineSugarIcon(sugar: wine.sugar, size: iconSize),
        WineAlcoholIcon(alcoholLevel: wine.alcoholLevel, size: iconSize),
        WineCountryIcon(country: wine.winery?.country, size: iconSize), // Предполагаем, что страна у винодельни
        WineGrapeIcon(grapeVariety: wine.grapeVariety, size: iconSize),
      ].where((widget) => !(widget is SizedBox)).toList(),
    );
  }
}
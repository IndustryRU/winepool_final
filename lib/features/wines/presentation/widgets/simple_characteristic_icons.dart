import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

// Простая иконка для ЦВЕТА
class SimpleColorIcon extends StatelessWidget {
  final WineColor? color;
  final double size;

  const SimpleColorIcon({super.key, required this.color, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    // Логика определения цвета, как мы обсуждали
    Color iconColor;
    switch (color) {
      case WineColor.red: iconColor = Colors.red; break;
      case WineColor.white: iconColor = Colors.white; break;
      case WineColor.rose: iconColor = Colors.pink.shade100; break;
      case WineColor.orange: iconColor = Colors.orange; break;
      default: iconColor = Colors.transparent;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor,
        shape: BoxShape.circle,
        border: color == WineColor.white ? Border.all(color: Colors.grey.shade400, width: 1.0) : null,
      ),
    );
  }
}

// Простая иконка для САХАРА
class SimpleSugarIcon extends StatelessWidget {
  final WineSugar? sugar;
  final double size;

  const SimpleSugarIcon({super.key, required this.sugar, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    // Логика определения сегментов, как в WineSugarIcon
    int filledSegments;
    switch (sugar) {
      case WineSugar.dry: filledSegments = 1; break;
      case WineSugar.semiDry: filledSegments = 2; break;
      case WineSugar.semiSweet: filledSegments = 3; break;
      case WineSugar.sweet: filledSegments = 4; break;
      default: return SizedBox(width: size, height: size);
    }

    return SizedBox(
      width: size / 2,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: List.generate(4, (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: index < filledSegments ? Colors.orange.shade300 : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        )).reversed.toList(),
      ),
    );
  }
}

// Простая иконка для ТИПА
class SimpleWineTypeIcon extends StatelessWidget {
  final WineType? type;
  final double size;

  const SimpleWineTypeIcon({super.key, required this.type, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color color;

    switch (type) {
      case WineType.still:
        iconData = Icons.waves;
        color = Colors.blue;
        break;
      case WineType.sparkling:
        iconData = Icons.bubble_chart;
        color = Colors.amber;
        break;
      case WineType.fortified:
        iconData = Icons.local_bar;
        color = Colors.deepPurple;
        break;
      default:
        return SizedBox(width: size, height: size);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: size * 0.6, color: color),
    );
  }
}

// Иконка для ВИНТАЖА
class VintageIcon extends StatelessWidget {
  final int vintage;
  final double size;

  const VintageIcon({super.key, required this.vintage, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    // Получаем последние две цифры года
    final shortYear = vintage.toString().substring(2);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade600,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          "'$shortYear",
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.5,
          ),
        ),
      ),
    );
  }
}
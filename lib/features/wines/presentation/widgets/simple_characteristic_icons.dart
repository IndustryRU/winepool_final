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
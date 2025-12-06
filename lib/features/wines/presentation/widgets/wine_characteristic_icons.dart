import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

/// Виджет для отображения пиктограммы цвета вина
class WineColorIcon extends StatefulWidget {
  final WineColor? color;
  final double size;

  const WineColorIcon({
    super.key,
    this.color,
    this.size = 20.0,
  });

  @override
  State<WineColorIcon> createState() => _WineColorIconState();
}

class _WineColorIconState extends State<WineColorIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Увеличил duration
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1), // Диагональное смещение
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showColorDescription() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    String colorDescription = '';
    switch (widget.color) {
      case WineColor.red:
        colorDescription = 'Красное вино';
      case WineColor.white:
        colorDescription = 'Белое вино';
      case WineColor.rose:
        colorDescription = 'Розовое вино';
      default:
        return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50,
        left: position.dx + size.width / 2 - 60,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    colorDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == null) {
      return const SizedBox.shrink();
    }

    Color iconColor;
    switch (widget.color) {
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

    return GestureDetector(
      onTap: _showColorDescription,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: iconColor,
          shape: BoxShape.circle,
          border: widget.color == WineColor.white
              ? Border.all(color: Colors.grey, width: 1.0)
              : null,
        ),
      ),
    );
  }
}

/// Виджет для отображения пиктограммы содержания сахара вине
class WineSugarIcon extends StatefulWidget {
  final WineSugar? sugar;
  final double size;

  const WineSugarIcon({
    super.key,
    this.sugar,
    this.size = 20.0,
  });

  @override
  State<WineSugarIcon> createState() => _WineSugarIconState();
}

class _WineSugarIconState extends State<WineSugarIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Увеличил duration
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1), // Диагональное смещение
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showSugarDescription() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    String sugarDescription = '';
    switch (widget.sugar) {
      case WineSugar.dry:
        sugarDescription = 'Сухое вино';
      case WineSugar.semiDry:
        sugarDescription = 'Полусухое вино';
      case WineSugar.semiSweet:
        sugarDescription = 'Полусладкое вино';
      case WineSugar.sweet:
        sugarDescription = 'Сладкое вино';
      default:
        return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50,
        left: position.dx + size.width / 2 - 60,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    sugarDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sugar == null) {
      return const SizedBox.shrink();
    }

    int filledSegments;
    switch (widget.sugar) {
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

    return GestureDetector(
      onTap: _showSugarDescription,
      child: SizedBox(
        width: widget.size / 2,
        height: widget.size,
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
      ),
    );
  }
}

/// Виджет для отображения пиктограммы крепости вина
class WineAlcoholIcon extends StatefulWidget {
  final double? alcoholLevel;
  final double size;

  const WineAlcoholIcon({
    super.key,
    this.alcoholLevel,
    this.size = 20.0,
  });

  @override
  State<WineAlcoholIcon> createState() => _WineAlcoholIconState();
}

class _WineAlcoholIconState extends State<WineAlcoholIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Увеличил duration
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1), // Диагональное смещение
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showAlcoholDescription() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    String alcoholDescription = 'Крепость: ${widget.alcoholLevel!.toStringAsFixed(1)}%';

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50,
        left: position.dx + size.width / 2 - 60,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    alcoholDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000)).then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.alcoholLevel == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _showAlcoholDescription,
      child: SizedBox(
        width: widget.size * 3, // Фиксированная ширина для WineAlcoholIcon (увеличенная в 2 раза)
        height: widget.size,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.2),
            borderRadius: BorderRadius.circular(widget.size / 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_drink,
                size: widget.size * 0.6,
                color: Colors.brown,
              ),
              const SizedBox(width: 2),
              FittedBox(
                child: Text(
                  '${widget.alcoholLevel!.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: widget.size * 0.6, // Увеличено на 30%
                    fontWeight: FontWeight.w500,
                    color: Colors.brown,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Виджет для отображения пиктограммы страны производства
class WineCountryIcon extends StatefulWidget {
  final String? countryCode;
  final String? countryName;
  final double size;

  const WineCountryIcon({
    super.key,
    this.countryCode,
    this.countryName,
    this.size = 20.0,
  });

  @override
  State<WineCountryIcon> createState() => _WineCountryIconState();
}

class _WineCountryIconState extends State<WineCountryIcon>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    print(widget.countryName);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Увеличил duration
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1), // Диагональное смещение
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut, // Изменил кривую для более плавной анимации
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showCountryDescription() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    String countryDescription = '';
    if (widget.countryName != null && widget.countryName!.isNotEmpty) {
      countryDescription = widget.countryName!;
    } else if (widget.countryCode != null) {
      countryDescription = widget.countryCode!;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 50,
        left: position.dx + size.width / 2 - 60,
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    countryDescription,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        if (_overlayEntry != null) {
          _overlayEntry!.remove();
          _overlayEntry = null;
          _animationController.reset();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.countryCode == null || widget.countryCode!.isEmpty) &&
        (widget.countryName == null || widget.countryName!.isEmpty)) {
      return const SizedBox.shrink();
    }

    // Используем countryCode как код страны, если он доступен, иначе используем countryName как отображаемое имя
    String displayCountryCode = '';
    if (widget.countryCode != null && widget.countryCode!.isNotEmpty) {
      displayCountryCode = widget.countryCode!;
    } else if (widget.countryName != null && widget.countryName!.isNotEmpty) {
      // Если у нас есть только countryName (полное название), мы не можем получить из него код страны
      // Вместо этого используем его как отображаемое имя
      displayCountryCode = widget.countryName!;
    }
    
    // Пытаемся использовать countryCode как код страны напрямую
    final countryCode = widget.countryCode != null && widget.countryCode!.isNotEmpty
        ? widget.countryCode!.toUpperCase()
        : '';
    if (_isValidCountryCode(countryCode)) {
      try {
        return GestureDetector(
          onTap: _showCountryDescription,
          child: SizedBox(
            width: widget.size * 3, // Фиксированная ширина для WineCountryIcon (увеличенная в 2 раза)
            height: widget.size,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: CountryFlag.fromCountryCode(countryCode),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    displayCountryCode,
                    style: TextStyle(
                      fontSize: widget.size * 0.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } catch (e) {
        // Если не удалось отобразить флаг по коду, отображаем текст
        return GestureDetector(
          onTap: _showCountryDescription,
          child: SizedBox(
            width: widget.size * 3, // Фиксированная ширина для WineCountryIcon (увеличенная в 2 раза)
            height: widget.size,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
              child: Text(
                displayCountryCode,
                style: TextStyle(
                  fontSize: widget.size * 0.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      // Если это не валидный код страны, просто отображаем текст
      return GestureDetector(
        onTap: _showCountryDescription,
        child: SizedBox(
          width: widget.size * 3, // Фиксированная ширина для WineCountryIcon (увеличенная в 2 раза)
          height: widget.size,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(widget.size / 2),
            ),
            child: Text(
              displayCountryCode,
              style: TextStyle(
                fontSize: widget.size * 0.6,
                fontWeight: FontWeight.w500,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );
    }
 }

  bool _isValidCountryCode(String code) {
    return code.length == 2 && code.toUpperCase() == code;
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
      height: size,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grain,
            size: size * 0.6,
            color: Colors.green,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              grapeVariety!,
              style: TextStyle(
                fontSize: size * 0.6, // Увеличено на 30%
                fontWeight: FontWeight.w500,
                color: Colors.green,
                height: 1.5, // Добавлен отступ между строками
              ),
              overflow: TextOverflow.ellipsis,
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
        WineCountryIcon(countryCode: wine.winery?.country, countryName: wine.winery?.countryName, size: iconSize), // Используем country и countryName у винодельни
        WineGrapeIcon(grapeVariety: wine.grapeVariety, size: iconSize),
      ].where((widget) => !(widget is SizedBox)).toList(),
    );
  }
}

/// Виджет для отображения всех пиктограмм характеристик вина в вертикальном расположении
class WineCharacteristicIconsColumn extends StatelessWidget {
  final Wine wine;
  final double iconSize;

  const WineCharacteristicIconsColumn({
    super.key,
    required this.wine,
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: [
        if (wine.color != null) WineColorIcon(color: wine.color, size: iconSize),
        if (wine.sugar != null) WineSugarIcon(sugar: wine.sugar, size: iconSize),
        if (wine.alcoholLevel != null) WineAlcoholIcon(alcoholLevel: wine.alcoholLevel, size: iconSize),
        if (wine.winery?.country != null) WineCountryIcon(countryCode: wine.winery?.country, countryName: wine.winery?.countryName, size: iconSize),
        if (wine.grapeVariety != null && wine.grapeVariety!.isNotEmpty) WineGrapeIcon(grapeVariety: wine.grapeVariety, size: iconSize),
      ],
    );
  }
}
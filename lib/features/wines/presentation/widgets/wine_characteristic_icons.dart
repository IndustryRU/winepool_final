import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:developer';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/features/wines/domain/grape_variety.dart';
import 'package:winepool_final/features/wines/presentation/wine_details_screen.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
      case WineColor.orange:
        colorDescription = 'Оранжевое вино';
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
      Future.delayed(const Duration(milliseconds: 2000)).then((_) {
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
        iconColor = Colors.pink.shade100;
      case WineColor.orange:
        iconColor = Colors.orange;
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
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
                  color: index < filledSegments ? Colors.orange.shade300 : Colors.grey[300],
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
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
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
            color: Colors.brown[100],
            borderRadius: BorderRadius.circular(widget.size / 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_drink,
                size: widget.size * 0.6,
                color: Colors.brown[800],
              ),
              const SizedBox(width: 2),
              FittedBox(
                child: Text(
                  '${widget.alcoholLevel!.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: widget.size * 0.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[800],
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

/// Виджет для отображения пиктограммы типа вина
class WineTypeIcon extends StatefulWidget {
  final WineType? type;
  final double size;

  const WineTypeIcon({
    super.key,
    this.type,
    this.size = 20.0,
  });

  @override
  State<WineTypeIcon> createState() => _WineTypeIconState();
}

class _WineTypeIconState extends State<WineTypeIcon>
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showTypeDescription() {
    if (_overlayEntry != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    String typeDescription = '';
    switch (widget.type) {
      case WineType.still:
        typeDescription = 'Тихое вино';
      case WineType.sparkling:
        typeDescription = 'Игристое вино';
      case WineType.fortified:
        typeDescription = 'Креплёное вино';
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
                    typeDescription,
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
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
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
    if (widget.type == null) {
      return const SizedBox.shrink();
    }

    Color color;
    switch (widget.type) {
      case WineType.still:
        color = Colors.blue;
      case WineType.sparkling:
        color = Colors.amber;
      case WineType.fortified:
        color = Colors.deepPurple;
      case WineType.unknown:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }

    IconData iconData;
    switch (widget.type) {
      case WineType.still:
        iconData = Icons.waves;
      case WineType.sparkling:
        iconData = Icons.bubble_chart;
      case WineType.fortified:
        iconData = Icons.local_bar;
      case WineType.unknown:
        return const SizedBox.shrink();
      default:
        return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _showTypeDescription,
      child: Container(
        width: widget.size,
        height: widget.size,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: widget.size * 0.8,
          color: color,
        ),
      ),
    );
  }
}

/// Виджет для отображения пиктограммы страны производства
class WineCountryIcon extends StatefulWidget {
  final Country? country;
 final double size;

  const WineCountryIcon({
    super.key,
    this.country,
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
    if (widget.country?.name != null) {
      log(widget.country!.name);
    }
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
    if (widget.country?.name != null && widget.country!.name.isNotEmpty) {
      countryDescription = widget.country!.name;
    } else if (widget.country?.code != null && widget.country!.code.isNotEmpty) {
      countryDescription = widget.country!.code;
    } else {
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
      Future.delayed(const Duration(milliseconds: 200)).then((_) {
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
    if ((widget.country?.code == null || widget.country!.code.isEmpty) &&
        (widget.country?.name == null || widget.country!.name.isEmpty)) {
      return const SizedBox.shrink();
    }

    // Используем код страны из объекта Country, если он доступен, иначе используем имя страны как отображаемое имя
    String displayCountryCode = '';
    if (widget.country?.code != null && widget.country!.code.isNotEmpty) {
      displayCountryCode = widget.country!.code;
    } else if (widget.country?.name != null && widget.country!.name.isNotEmpty) {
      // Если у нас есть только имя страны (полное название), мы не можем получить из него код страны
      // Вместо этого используем его как отображаемое имя
      displayCountryCode = widget.country!.name;
    }
    
    // Пытаемся использовать код страны из объекта Country напрямую
    final countryCode = widget.country?.code != null && widget.country!.code.isNotEmpty
        ? widget.country!.code.toUpperCase()
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
                color: Colors.blue[100],
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
                      color: Colors.blue[800],
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
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
              child: Text(
                displayCountryCode,
                style: TextStyle(
                  fontSize: widget.size * 0.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[800],
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
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(widget.size / 2),
            ),
            child: Text(
              widget.country?.name ?? displayCountryCode,
              style: TextStyle(
                fontSize: widget.size * 0.6,
                fontWeight: FontWeight.w500,
                color: Colors.blue[800],
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

/// Виджет для отображения пиктограммы винтажа
class WineVintageIcon extends StatefulWidget {
  final int? vintage;
  final double size;

  const WineVintageIcon({
    super.key,
    this.vintage,
    this.size = 20.0,
  });

  @override
  State<WineVintageIcon> createState() => _WineVintageIconState();
}

class _WineVintageIconState extends State<WineVintageIcon>
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.1, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _showVintageDescription() {
    if (_overlayEntry != null || widget.vintage == null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final vintageDescription = 'Винтаж ${widget.vintage}';

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 30, // Скорректируем позицию, чтобы было видно
        left: position.dx + size.width / 2 - (vintageDescription.length * 4), // Примерный расчет центра
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
                    vintageDescription,
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
      Future.delayed(const Duration(milliseconds: 2000)).then((_) {
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
    if (widget.vintage == null) {
      return const SizedBox.shrink();
    }

    // Используем твой оригинальный дизайн
    final shortYear = widget.vintage.toString().length > 2
        ? widget.vintage.toString().substring(widget.vintage.toString().length - 2)
        : widget.vintage.toString();

    return GestureDetector(
      onTap: _showVintageDescription,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade600,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            "'$shortYear",
            style: TextStyle(
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: widget.size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

/// Виджет для отображения всех пиктограмм характеристик вина
class WineCharacteristicIconsRow extends ConsumerWidget {
  final Wine wine;
  final double iconSize;

  const WineCharacteristicIconsRow({
    super.key,
    required this.wine,
    this.iconSize = 20.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = wine.grapeVarietyIds;
    final colorIcon = WineColorIcon(color: wine.color, size: iconSize);
    final sugarIcon = WineSugarIcon(sugar: wine.sugar, size: iconSize);
    final typeIcon = WineTypeIcon(type: wine.type, size: iconSize);
    final alcoholIcon = WineAlcoholIcon(alcoholLevel: wine.alcoholLevel, size: iconSize);
    final countryIcon = WineCountryIcon(country: wine.winery?.country, size: iconSize);
    
    // Получаем все уникальные винтажи из доступных предложений
    final uniqueVintages = _getUniqueSortedVintages(wine.offers);
    final vintageIcons = uniqueVintages.map((v) => Padding(
      padding: const EdgeInsets.only(right: 6.0), // Добавляем отступ между иконками винтажа
      child: WineVintageIcon(vintage: v, size: iconSize),
    )).toList();

    if (ids == null || ids.isEmpty) {
      final List<Widget> iconList = [
        colorIcon, 
        sugarIcon, 
        typeIcon, 
        alcoholIcon, 
        countryIcon
      ];
      
      iconList.addAll(vintageIcons);
      
      return Wrap(
        spacing: 3,
        runSpacing: 0,
        children: iconList
            .where((widget) => !(widget is SizedBox))
            .toList(),
      );
    }

    final grapeVarietiesAsync = ref.watch(fetchGrapeVarietiesByIdsProvider(ids));

    return grapeVarietiesAsync.when(
      data: (grapeVarieties) {
        final names = grapeVarieties.map((e) => e.name).join(', ');
        
        final List<Widget> iconList = [
          colorIcon,
          sugarIcon,
          typeIcon,
          alcoholIcon,
          countryIcon,
        ];
        
        iconList.addAll(vintageIcons);
        
        iconList.add(_buildGrapeVarietyIcon(names, iconSize));
        
        return Wrap(
          spacing: 3,
          runSpacing: 0,
          children: iconList
              .where((widget) => !(widget is SizedBox))
              .toList(),
        );
      },
      loading: () {
        final List<Widget> iconList = [
          colorIcon, 
          sugarIcon, 
          typeIcon, 
          alcoholIcon, 
          countryIcon
        ];
        
        iconList.addAll(vintageIcons);
        
        return Wrap(
          spacing: 3,
          runSpacing: 0,
          children: iconList
              .where((widget) => !(widget is SizedBox))
              .toList(),
        );
      },
      error: (error, stack) {
        final List<Widget> iconList = [
          colorIcon, 
          sugarIcon, 
          typeIcon, 
          alcoholIcon, 
          countryIcon
        ];
        
        iconList.addAll(vintageIcons);
        
        return Wrap(
          spacing: 3,
          runSpacing: 0,
          children: iconList
              .where((widget) => !(widget is SizedBox))
              .toList(),
        );
      },
    );
  }

  Widget _buildGrapeVarietyIcon(String names, double size) {
    if (names.isEmpty) {
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
              names,
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
  
  /// Метод для получения всех уникальных винтажей из списка предложений
  List<int> _getUniqueSortedVintages(List<Offer>? offers) {
    if (offers == null || offers.isEmpty) {
      return [];
    }
    final vintages = offers
        .map((offer) => offer.vintage)
        .where((v) => v != null)
        .cast<int>()
        .toSet()
        .toList();
    vintages.sort((a, b) => b.compareTo(a)); // Сортируем по убыванию (сначала новые)
    return vintages;
  }
}

/// Виджет для отображения всех пиктограмм характеристик вина вертикальном расположении
class WineCharacteristicIconsColumn extends ConsumerWidget {
  final Wine wine;
  final double iconSize;
  final bool isSearch;

  const WineCharacteristicIconsColumn({
    super.key,
    required this.wine,
    this.iconSize = 20.0,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('--- ГДЕ ЭТОТ КОМЕНТАРИЙ? ---');
    if (wine.winery != null) {
      log(wine.winery.toString());
    }
    print(wine.winery?.country);
    final ids = wine.grapeVarietyIds;
    final colorIcon = wine.color != null ? WineColorIcon(color: wine.color, size: iconSize) : null;
    final sugarIcon = wine.sugar != null ? WineSugarIcon(sugar: wine.sugar, size: iconSize) : null;
    final typeIcon = wine.type != null ? WineTypeIcon(type: wine.type, size: iconSize) : null;
    final alcoholIcon = wine.alcoholLevel != null ? WineAlcoholIcon(alcoholLevel: wine.alcoholLevel, size: iconSize) : null;
    Widget? countryIcon;
    if (wine.winery?.country != null) {
      countryIcon = WineCountryIcon(
        country: isSearch
            ? Country(code: wine.winery?.countryCode ?? '', name: wine.winery?.country?.code ?? '')
            : wine.winery?.country,
        size: iconSize,
      );
    }
    
    // Получаем все уникальные винтажи из доступных предложений
    final uniqueVintages = _getUniqueSortedVintages(wine.offers);
    final vintageIcons = uniqueVintages.map((v) => Padding(
      padding: const EdgeInsets.only(right: 3.0), // Добавляем отступ между иконками винтажа
      child: WineVintageIcon(vintage: v, size: iconSize),
    )).toList();

    final iconsList = <Widget>[];
    if (colorIcon != null) iconsList.add(colorIcon);
    if (sugarIcon != null) iconsList.add(sugarIcon);
    if (typeIcon != null) iconsList.add(typeIcon);
    if (alcoholIcon != null) iconsList.add(alcoholIcon);
    if (countryIcon != null) iconsList.add(countryIcon);

    // Добавляем все винтажные иконки
    iconsList.addAll(vintageIcons);

    if (ids == null || ids.isEmpty) {
      return Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: iconsList,
      );
    }

    final grapeVarietiesAsync = ref.watch(fetchGrapeVarietiesByIdsProvider(ids));

    return grapeVarietiesAsync.when(
      data: (grapeVarieties) {
        final names = grapeVarieties.map((e) => e.name).join(', ');
        final grapeIcon = _buildGrapeVarietyIcon(names, iconSize);
        return Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          alignment: WrapAlignment.center,
          children: [...iconsList, grapeIcon],
        );
      },
      loading: () => Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: iconsList,
      ),
      error: (error, stack) => Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: iconsList,
      ),
    );
  }

  Widget _buildGrapeVarietyIcon(String names, double size) {
    if (names.isEmpty) {
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
              names,
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
  
  /// Метод для получения всех уникальных винтажей из списка предложений
  List<int> _getUniqueSortedVintages(List<Offer>? offers) {
    if (offers == null || offers.isEmpty) {
      return [];
    }
    final vintages = offers
        .map((offer) => offer.vintage)
        .where((v) => v != null)
        .cast<int>()
        .toSet()
        .toList();
    vintages.sort((a, b) => b.compareTo(a)); // Сортируем по убыванию (сначала новые)
    return vintages;
  }
}

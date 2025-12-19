import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OcrService { google, tesseract, yandex }

class OcrServiceNotifier extends Notifier<OcrService> {
  @override
  OcrService build() {
    _loadOcrService();
    return OcrService.google; // Значение по умолчанию
  }

  Future<void> _loadOcrService() async {
    final prefs = await SharedPreferences.getInstance();
    final serviceName = prefs.getString('ocr_service') ?? OcrService.google.name;
    state = OcrService.values.byName(serviceName);
  }

  Future<void> setOcrService(OcrService service) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ocr_service', service.name);
    state = service;
  }
}

final ocrServiceProvider = NotifierProvider<OcrServiceNotifier, OcrService>(OcrServiceNotifier.new);
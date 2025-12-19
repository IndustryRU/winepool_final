import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/yandex_cloud_config.dart'; // Импортируем наш конфиг

class YandexCloudAuthService {
  static const String _tokenEndpoint = 'https://iam.api.cloud.yandex.net/iam/v1/tokens';
  // static const String _serviceAccountId = 'your_service_account_id'; // Заменить на ID сервисного аккаунта
  // static const String _privateKeyId = 'your_key_id'; // Заменить на ID ключа
  // static const String _privateKeyValue = '''-----BEGIN PRIVATE KEY-----
  // MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC...
  // -----END PRIVATE KEY-----'''; // Заменить на приватный ключ

  /// Получает IAM-токен для аутентификации в Yandex Cloud API.
  static Future<String> getIamToken() async {
    final jwt = _generateJwt();
    final response = await http.post(
      Uri.parse(_tokenEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'jwt': jwt}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['iamToken'];
    } else {
      throw Exception('Failed to get IAM token: ${response.statusCode}, ${response.body}');
    }
  }

  /// Генерирует JWT-токен для получения IAM-токена.
  static String _generateJwt() {
    final header = base64UrlEncode(utf8.encode(jsonEncode({'alg': 'PS256', 'typ': 'JWT'})));
    final payload = base64UrlEncode(utf8.encode(jsonEncode({
      // 'iss': YandexCloudConfig.serviceAccountId, // Используем значение из конфига
      // 'sub': YandexCloudConfig.serviceAccountId, // Используем значение из конфига
      'iss': '', // Временно пусто, так как используем API-ключ
      'sub': '', // Временно пусто, так как используем API-ключ
      'aud': _tokenEndpoint,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': (DateTime.now().add(Duration(hours: 1))).millisecondsSinceEpoch ~/ 1000,
    })));

    final unsignedJwt = '$header.$payload';

    // Подпись JWT с использованием приватного ключа (псевдокод)
    // final signature = signWithPrivateKey(unsignedJwt, _privateKeyValue);
    // final signedJwt = '$unsignedJwt.${base64UrlEncode(signature)}';

    // Пока возвращаем неподписанный JWT, чтобы не хранить приватный ключ в открытом виде
    // В реальности подпись должна происходить на бэкенде или в безопасной среде
    return unsignedJwt;
  }

  /// Получает ID каталога из настроек приложения.
  static Future<String> getFolderId() async {
    // return 'your_folder_id'; // Заменить на ID каталога
    return YandexCloudConfig.folderId; // Используем значение из конфига
  }
}
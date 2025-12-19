// lib/config/yandex_cloud_config.dart
import 'package:envied/envied.dart';

part 'yandex_cloud_config.g.dart';

@Envied(path: '.env', requireEnvFile: true)
abstract class YandexCloudConfig {
  // @EnviedField(varName: 'YANDEX_SERVICE_ACCOUNT_ID', obfuscate: false)
  // static final String serviceAccountId = _YandexCloudConfig.serviceAccountId;

  // @EnviedField(varName: 'YANDEX_KEY_ID', obfuscate: false)
  // static final String keyId = _YandexCloudConfig.keyId;

  // @EnviedField(varName: 'YANDEX_PRIVATE_KEY_VALUE', obfuscate: true) // obfuscate: true для приватных данных
  // static final String privateKeyValue = _YandexCloudConfig.privateKeyValue;

  @EnviedField(varName: 'YANDEX_FOLDER_ID', obfuscate: false)
  static final String folderId = _YandexCloudConfig.folderId;

  @EnviedField(varName: 'YANDEX_API_KEY', obfuscate: true) // obfuscate: true для API-ключа
  static final String apiKey = _YandexCloudConfig.apiKey;
}
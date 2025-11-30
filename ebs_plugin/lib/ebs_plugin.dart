
import 'native_api.g.dart';
import 'ebs_plugin_platform_interface.dart';

class EbsPlugin {
  Future<String?> getPlatformVersion() {
    return EbsPluginPlatform.instance.getPlatformVersion();
  }

  Future<EbsResultData> requestVerification({
    required String infoSystem,
    required String adapterUri,
    required String sid,
    required String dboKoUri,
    required String dbkKoPublicUri,
  }) async {
    return await NativeHostApi().requestVerification(
      infoSystem: infoSystem,
      adapterUri: adapterUri,
      sid: sid,
      dboKoUri: dboKoUri,
      dbkKoPublicUri: dbkKoPublicUri,
    );
  }

  Future<bool> isInstalledApp() async {
    return await NativeHostApi().isInstalledApp();
  }

  Future<String> getAppName() async {
    return await NativeHostApi().getAppName();
  }

  Future<String> getRequestInstallAppText() async {
    return await NativeHostApi().getRequestInstallAppText();
  }

  Future<bool> requestInstallApp() async {
    return await NativeHostApi().requestInstallApp();
  }
}

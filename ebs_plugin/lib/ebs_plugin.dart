
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
}

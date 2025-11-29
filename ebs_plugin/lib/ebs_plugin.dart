
import 'ebs_plugin_platform_interface.dart';

class EbsPlugin {
  Future<String?> getPlatformVersion() {
    return EbsPluginPlatform.instance.getPlatformVersion();
  }
}

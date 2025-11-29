import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ebs_plugin_platform_interface.dart';

/// An implementation of [EbsPluginPlatform] that uses method channels.
class MethodChannelEbsPlugin extends EbsPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ebs_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

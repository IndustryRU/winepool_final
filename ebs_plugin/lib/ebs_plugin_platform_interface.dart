import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ebs_plugin_method_channel.dart';

abstract class EbsPluginPlatform extends PlatformInterface {
  /// Constructs a EbsPluginPlatform.
  EbsPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static EbsPluginPlatform _instance = MethodChannelEbsPlugin();

  /// The default instance of [EbsPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelEbsPlugin].
  static EbsPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EbsPluginPlatform] when
  /// they register themselves.
  static set instance(EbsPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

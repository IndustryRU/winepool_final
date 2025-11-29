import 'package:flutter_test/flutter_test.dart';
import 'package:ebs_plugin/ebs_plugin.dart';
import 'package:ebs_plugin/ebs_plugin_platform_interface.dart';
import 'package:ebs_plugin/ebs_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEbsPluginPlatform
    with MockPlatformInterfaceMixin
    implements EbsPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final EbsPluginPlatform initialPlatform = EbsPluginPlatform.instance;

  test('$MethodChannelEbsPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEbsPlugin>());
  });

  test('getPlatformVersion', () async {
    EbsPlugin ebsPlugin = EbsPlugin();
    MockEbsPluginPlatform fakePlatform = MockEbsPluginPlatform();
    EbsPluginPlatform.instance = fakePlatform;

    expect(await ebsPlugin.getPlatformVersion(), '42');
  });
}

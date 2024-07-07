import 'package:flutter_test/flutter_test.dart';
import 'package:ngenius_sdk/ngenius_sdk.dart';
import 'package:ngenius_sdk/ngenius_sdk_platform_interface.dart';
import 'package:ngenius_sdk/ngenius_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNgeniusSdkPlatform
    with MockPlatformInterfaceMixin
    implements NgeniusSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NgeniusSdkPlatform initialPlatform = NgeniusSdkPlatform.instance;

  test('$MethodChannelNgeniusSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNgeniusSdk>());
  });

  test('getPlatformVersion', () async {
    NgeniusSdk ngeniusSdkPlugin = NgeniusSdk();
    MockNgeniusSdkPlatform fakePlatform = MockNgeniusSdkPlatform();
    NgeniusSdkPlatform.instance = fakePlatform;

    expect(await ngeniusSdkPlugin.getPlatformVersion(), '42');
  });
}

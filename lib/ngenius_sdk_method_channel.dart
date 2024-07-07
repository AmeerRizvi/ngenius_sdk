import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'ngenius_sdk_platform_interface.dart';

/// An implementation of [NgeniusSdkPlatform] that uses method channels.
class MethodChannelNgeniusSdk extends NgeniusSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('ngenius_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

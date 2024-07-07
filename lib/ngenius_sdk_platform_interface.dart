import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ngenius_sdk_method_channel.dart';

abstract class NgeniusSdkPlatform extends PlatformInterface {
  /// Constructs a NgeniusSdkPlatform.
  NgeniusSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static NgeniusSdkPlatform _instance = MethodChannelNgeniusSdk();

  /// The default instance of [NgeniusSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelNgeniusSdk].
  static NgeniusSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NgeniusSdkPlatform] when
  /// they register themselves.
  static set instance(NgeniusSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

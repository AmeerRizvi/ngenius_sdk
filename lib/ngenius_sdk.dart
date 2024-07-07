
import 'ngenius_sdk_platform_interface.dart';

class NgeniusSdk {
  Future<String?> getPlatformVersion() {
    return NgeniusSdkPlatform.instance.getPlatformVersion();
  }
}

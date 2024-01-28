import 'flutter_hardware_buttons_platform_interface.dart';

class FlutterHardwareButtons {
  Future<String?> getPlatformVersion() {
    return FlutterHardwareButtonsPlatform.instance.getPlatformVersion();
  }

  Future<void> startListeningForHardwareButtons() {
    return FlutterHardwareButtonsPlatform.instance
        .startListeningForHardwareButtons();
  }

  Future<void> stopListeningForHardwareButtons() {
    return FlutterHardwareButtonsPlatform.instance
        .stopListeningForHardwareButtons();
  }
}

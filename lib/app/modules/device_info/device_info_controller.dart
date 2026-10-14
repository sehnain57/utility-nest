import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoItem {
  final String label;
  final String value;
  DeviceInfoItem(this.label, this.value);
}

class DeviceInfoController extends GetxController {
  final items = <DeviceInfoItem>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final result = <DeviceInfoItem>[];
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        result.addAll([
          DeviceInfoItem('Brand', info.brand),
          DeviceInfoItem('Model', info.model),
          DeviceInfoItem('Manufacturer', info.manufacturer),
          DeviceInfoItem('Android Version', info.version.release),
          DeviceInfoItem('SDK Level', '${info.version.sdkInt}'),
          DeviceInfoItem('Device', info.device),
          DeviceInfoItem('Board', info.board),
          DeviceInfoItem('Physical Device', info.isPhysicalDevice ? 'Yes' : 'No'),
        ]);
      } else if (Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        result.addAll([
          DeviceInfoItem('Name', info.name),
          DeviceInfoItem('Model', info.model),
          DeviceInfoItem('System Name', info.systemName),
          DeviceInfoItem('System Version', info.systemVersion),
          DeviceInfoItem('Physical Device', info.isPhysicalDevice ? 'Yes' : 'No'),
        ]);
      }

      final packageInfo = await PackageInfo.fromPlatform();
      result.addAll([
        DeviceInfoItem('App Name', packageInfo.appName),
        DeviceInfoItem('Package Name', packageInfo.packageName),
        DeviceInfoItem('App Version', '${packageInfo.version} (${packageInfo.buildNumber})'),
      ]);
    } catch (_) {
      result.add(DeviceInfoItem('Error', 'Could not read device info'));
    }
    items.assignAll(result);
    isLoading.value = false;
  }
}

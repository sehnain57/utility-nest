import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final _box = GetStorage();
  static const _key = 'is_dark_mode';
  final isDarkMode = true.obs;

  static const String privacyPolicyUrl =
      'https://www.freeprivacypolicy.com/live/5ee4c535-1eb4-4123-8e2a-3cb4895d17aa';

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _box.read(_key) ?? true;
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    _box.write(_key, value);
  }

  void shareApp() {
    Share.share(
      'Check out Utility Nest — an ultra-modern daily toolkit with world clock, habit & water tracker, typing test, and more!\nhttps://play.google.com/store/apps/details?id=com.yourcompany.utilitynest',
    );
  }

  Future<void> rateApp() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.yourcompany.utilitynest',
    );
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      Get.snackbar(
        'Rate Us',
        'Thank you for using Utility Nest!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> openPrivacyPolicy() async {
    final uri = Uri.parse(privacyPolicyUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri);
      }
    } catch (_) {
      Get.snackbar(
        'Notice',
        'Unable to open browser. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

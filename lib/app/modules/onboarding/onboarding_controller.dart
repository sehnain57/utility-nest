import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';

class OnboardPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  OnboardPage({required this.title, required this.description, required this.icon, required this.gradient});
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;
  final _box = GetStorage();

  final pages = [
    OnboardPage(
      title: 'Eight Tools.\nOne Nest.',
      description: 'World clock, habit tracker, EMI calculator, typing test and more — all in one clean app.',
      icon: Icons.auto_awesome_mosaic_rounded,
      gradient: AppColors.gradLime,
    ),
    OnboardPage(
      title: 'Private by Design',
      description: 'No camera, no microphone, no accounts. Everything stays on your device.',
      icon: Icons.shield_moon_rounded,
      gradient: AppColors.gradSky,
    ),
    OnboardPage(
      title: 'Built to Look Great',
      description: 'A fresh, modern interface designed for speed and clarity.',
      icon: Icons.auto_fix_high_rounded,
      gradient: AppColors.gradViolet,
    ),
  ];

  void onPageChanged(int index) => currentPage.value = index;

  void next() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      finish();
    }
  }

  void skip() => finish();

  void finish() {
    _box.write('onboarding_seen', true);
    Get.offAllNamed(AppRoutes.home);
  }
}

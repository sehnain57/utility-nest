import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {
  final _box = GetStorage();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 1500), () {
      final seenOnboarding = _box.read('onboarding_seen') ?? false;
      Get.offAllNamed(seenOnboarding ? AppRoutes.home : AppRoutes.onboarding);
    });
  }
}

import 'package:get/get.dart';

import '../modules/splash/splash_screen.dart';
import '../modules/onboarding/onboarding_screen.dart';
import '../modules/home/home_screen.dart';
import '../modules/home/home_controller.dart';
import '../modules/world_clock/world_clock_screen.dart';
import '../modules/world_clock/world_clock_controller.dart';
import '../modules/habit_tracker/habit_tracker_screen.dart';
import '../modules/habit_tracker/habit_tracker_controller.dart';
import '../modules/water_tracker/water_tracker_screen.dart';
import '../modules/water_tracker/water_tracker_controller.dart';
import '../modules/random_picker/random_picker_screen.dart';
import '../modules/random_picker/random_picker_controller.dart';
import '../modules/emi_calculator/emi_calculator_screen.dart';
import '../modules/emi_calculator/emi_calculator_controller.dart';
import '../modules/typing_test/typing_test_screen.dart';
import '../modules/typing_test/typing_test_controller.dart';
import '../modules/event_countdown/event_countdown_screen.dart';
import '../modules/event_countdown/event_countdown_controller.dart';
import '../modules/device_info/device_info_screen.dart';
import '../modules/device_info/device_info_controller.dart';
import '../modules/settings/settings_screen.dart';
import '../modules/settings/settings_controller.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.worldClock,
      page: () => const WorldClockScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => WorldClockController())),
    ),
    GetPage(
      name: AppRoutes.habitTracker,
      page: () => const HabitTrackerScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => HabitTrackerController())),
    ),
    GetPage(
      name: AppRoutes.waterTracker,
      page: () => const WaterTrackerScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => WaterTrackerController())),
    ),
    GetPage(
      name: AppRoutes.randomPicker,
      page: () => const RandomPickerScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => RandomPickerController())),
    ),
    GetPage(
      name: AppRoutes.emiCalculator,
      page: () => const EmiCalculatorScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => EmiCalculatorController())),
    ),
    GetPage(
      name: AppRoutes.typingTest,
      page: () => const TypingTestScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => TypingTestController())),
    ),
    GetPage(
      name: AppRoutes.eventCountdown,
      page: () => const EventCountdownScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => EventCountdownController())),
    ),
    GetPage(
      name: AppRoutes.deviceInfo,
      page: () => const DeviceInfoScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => DeviceInfoController())),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => SettingsController())),
    ),
  ];
}

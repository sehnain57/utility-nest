import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const UtilityNestApp());
}

class UtilityNestApp extends StatelessWidget {
  const UtilityNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = GetStorage().read('is_dark_mode') ?? true;
    return SafeArea(
      top: false,
      child: GetMaterialApp(
        title: 'Utility Nest',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}

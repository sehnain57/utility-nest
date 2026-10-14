import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: c.skip, child: Text('Skip', style: TextStyle(color: Colors.white.withOpacity(0.6)))),
            ),
            Expanded(
              child: PageView.builder(
                controller: c.pageController,
                onPageChanged: c.onPageChanged,
                itemCount: c.pages.length,
                itemBuilder: (context, index) {
                  final page = c.pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: page.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(38),
                            boxShadow: [BoxShadow(color: page.gradient.first.withOpacity(0.4), blurRadius: 40, spreadRadius: 4)],
                          ),
                          child: Icon(page.icon, color: Colors.black, size: 60),
                        ),
                        const SizedBox(height: 40),
                        Text(page.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        Text(page.description, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.55), height: 1.5)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    c.pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: c.currentPage.value == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: c.currentPage.value == i ? AppColors.lime : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: Obx(() => ElevatedButton(
                      onPressed: c.next,
                      child: Text(c.currentPage.value == c.pages.length - 1 ? 'Get Started' : 'Next'),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

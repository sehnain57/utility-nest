import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'device_info_controller.dart';

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DeviceInfoController>();

    return Scaffold(
      appBar: ToolHeader(title: 'Device Info', subtitle: 'Your device at a glance', gradient: AppColors.gradLime, icon: Icons.phone_android_rounded),
      body: Obx(() {
        if (c.isLoading.value) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: c.items.length,
          itemBuilder: (context, index) {
            final item = c.items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    Flexible(
                      child: Text(item.value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

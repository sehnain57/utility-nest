import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'water_tracker_controller.dart';

class WaterTrackerScreen extends StatelessWidget {
  const WaterTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WaterTrackerController>();

    return Scaffold(
      appBar: ToolHeader(title: 'Water Tracker', subtitle: 'Stay hydrated every day', gradient: AppColors.gradMint, icon: Icons.water_drop_rounded),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => GlassCard(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: CircularProgressIndicator(
                              value: c.progress,
                              strokeWidth: 12,
                              backgroundColor: AppColors.mint.withOpacity(0.15),
                              valueColor: const AlwaysStoppedAnimation(AppColors.mint),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${c.currentIntake.value}', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                              Text('/ ${c.dailyGoal.value} ml', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text('${(c.progress * 100).round()}% of daily goal', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    ],
                  ),
                )),
            const SizedBox(height: 20),
            Row(
              children: [100, 250, 500].map((ml) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: OutlinedButton(
                      onPressed: () => c.addWater(ml),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        side: const BorderSide(color: AppColors.mint),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.local_drink_rounded, color: AppColors.mint),
                          const SizedBox(height: 6),
                          Text('+$ml ml'),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: c.reset, child: const Text('Reset Today')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showGoalDialog(context, c),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: Colors.white),
                    child: const Text('Set Goal'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context, WaterTrackerController c) {
    final controller = TextEditingController(text: c.dailyGoal.value.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Daily goal (ml)'),
        content: TextField(controller: controller, keyboardType: TextInputType.number),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final v = int.tryParse(controller.text);
              if (v != null && v > 0) c.setGoal(v);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

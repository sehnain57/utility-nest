import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'habit_tracker_controller.dart';

class HabitTrackerScreen extends StatelessWidget {
  const HabitTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<HabitTrackerController>();

    return Scaffold(
      appBar: ToolHeader(title: 'Habit Tracker', subtitle: 'Build streaks, one day at a time', gradient: AppColors.gradCoral, icon: Icons.local_fire_department_rounded),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.coral,
        onPressed: () => _showAddSheet(context, c),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Obx(() {
        if (c.habits.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_rounded, size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No habits yet — add one!', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
          itemCount: c.habits.length,
          itemBuilder: (context, index) {
            final habit = c.habits[index];
            final done = c.isDoneToday(habit);
            final streak = c.streakFor(habit);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(habit.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => c.deleteHabit(habit.id),
                child: GlassCard(
                  onTap: () => c.toggleToday(habit.id),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: done ? const LinearGradient(colors: AppColors.gradCoral) : null,
                          color: done ? null : Colors.grey.withOpacity(0.15),
                        ),
                        child: Icon(done ? Icons.check_rounded : Icons.local_fire_department_outlined, color: done ? Colors.white : Colors.grey),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(habit.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text('$streak day streak', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                      Text(done ? 'Done' : 'Tap', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: done ? AppColors.coral : Colors.grey)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddSheet(BuildContext context, HabitTrackerController c) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('New habit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: c.inputController,
                decoration: const InputDecoration(hintText: 'e.g. Drink water, Read 10 pages'),
                onSubmitted: (v) {
                  c.addHabit(v);
                  Get.back();
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    c.addHabit(c.inputController.text);
                    Get.back();
                  },
                  child: const Text('Add Habit'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

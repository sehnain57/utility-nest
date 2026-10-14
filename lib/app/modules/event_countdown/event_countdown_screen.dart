import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'event_countdown_controller.dart';

class EventCountdownScreen extends StatelessWidget {
  const EventCountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EventCountdownController>();

    return Scaffold(
      appBar: ToolHeader(title: 'Event Countdown', subtitle: 'Never miss a big moment', gradient: AppColors.gradRose, icon: Icons.event_rounded),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.violet,
        onPressed: () => _showAddSheet(context, c),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Obx(() {
        if (c.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.hourglass_empty_rounded, size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No events yet', style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
          itemCount: c.events.length,
          itemBuilder: (context, index) {
            final event = c.events[index];
            final remaining = c.remaining(event);
            final days = remaining.inDays;
            final hours = remaining.inHours % 24;
            final minutes = remaining.inMinutes % 60;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(event.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(22)),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                onDismissed: (_) => c.deleteEvent(event.id),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(DateFormat('dd MMM yyyy, HH:mm').format(event.targetDate), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _countUnit('$days', 'Days'),
                          _countUnit('$hours', 'Hrs'),
                          _countUnit('$minutes', 'Min'),
                        ],
                      ),
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

  Widget _countUnit(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.violet)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  void _showAddSheet(BuildContext context, EventCountdownController c) {
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
              const Text('New event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(controller: c.titleController, decoration: const InputDecoration(hintText: 'e.g. Birthday, Exam, Trip')),
              const SizedBox(height: 12),
              Obx(() => InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                      if (time == null) return;
                      c.setDate(DateTime(date.year, date.month, date.day, time.hour, time.minute));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: AppColors.violet),
                          const SizedBox(width: 12),
                          Text(c.selectedDate.value == null ? 'Pick date & time' : DateFormat('dd MMM yyyy, HH:mm').format(c.selectedDate.value!)),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    c.addEvent();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.violet, foregroundColor: Colors.white),
                  child: const Text('Add Event'),
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

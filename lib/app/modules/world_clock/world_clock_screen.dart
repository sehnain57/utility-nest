import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../widgets/tool_header.dart';
import '../../widgets/glass_card.dart';
import 'world_clock_controller.dart';

class WorldClockScreen extends StatelessWidget {
  const WorldClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorldClockController>();

    return Scaffold(
      appBar: ToolHeader(title: 'World Clock', subtitle: 'Track time across the globe', gradient: AppColors.gradSky, icon: Icons.public_rounded),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.sky,
        onPressed: () => _showAddCitySheet(context, c),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
            itemCount: c.selectedCities.length,
            itemBuilder: (context, index) {
              final city = c.selectedCities[index];
              final time = c.timeFor(city);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Dismissible(
                  key: ValueKey(city),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(color: AppColors.coral, borderRadius: BorderRadius.circular(22)),
                    child: const Icon(Icons.delete_rounded, color: Colors.white),
                  ),
                  onDismissed: (_) => c.removeCity(city),
                  child: GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(c.formattedOffset(city), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(DateFormat('HH:mm:ss').format(time), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                            Text(DateFormat('EEE, d MMM').format(time), style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  void _showAddCitySheet(BuildContext context, WorldClockController c) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final available = c.allCities.keys.where((city) => !c.selectedCities.contains(city)).toList();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add a city', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: available.isEmpty
                      ? const Center(child: Text('All cities added'))
                      : ListView.builder(
                          itemCount: available.length,
                          itemBuilder: (context, index) {
                            final city = available[index];
                            return ListTile(
                              title: Text(city),
                              subtitle: Text(c.formattedOffset(city)),
                              onTap: () {
                                c.addCity(city);
                                Get.back();
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

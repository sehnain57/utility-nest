import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'habit_model.dart';

class HabitTrackerController extends GetxController {
  final _box = GetStorage();
  static const _key = 'habits_list';
  final inputController = TextEditingController();
  final habits = <HabitModel>[].obs;

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = _box.read<String>(_key);
    if (raw == null || raw.isEmpty) return;
    habits.assignAll((jsonDecode(raw) as List).map((e) => HabitModel.fromJson(e)));
  }

  void _persist() => _box.write(_key, jsonEncode(habits.map((e) => e.toJson()).toList()));

  void addHabit(String name) {
    if (name.trim().isEmpty) return;
    habits.add(HabitModel(id: const Uuid().v4(), name: name.trim()));
    inputController.clear();
    _persist();
  }

  void deleteHabit(String id) {
    habits.removeWhere((h) => h.id == id);
    _persist();
  }

  bool isDoneToday(HabitModel habit) => habit.completedDates.contains(_today);

  void toggleToday(String id) {
    final habit = habits.firstWhereOrNull((h) => h.id == id);
    if (habit == null) return;
    if (habit.completedDates.contains(_today)) {
      habit.completedDates.remove(_today);
    } else {
      habit.completedDates.add(_today);
    }
    habits.refresh();
    _persist();
  }

  /// Current consecutive-day streak counting backward from today.
  int streakFor(HabitModel habit) {
    int streak = 0;
    DateTime cursor = DateTime.now();
    while (habit.completedDates.contains(DateFormat('yyyy-MM-dd').format(cursor))) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}

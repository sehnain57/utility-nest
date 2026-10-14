import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';
import 'event_model.dart';

class EventCountdownController extends GetxController {
  final _box = GetStorage();
  static const _key = 'events_list';

  final events = <EventModel>[].obs;
  final now = DateTime.now().obs;
  Timer? _ticker;

  final titleController = TextEditingController();
  final selectedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    _load();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => now.value = DateTime.now());
  }

  void _load() {
    final raw = _box.read<String>(_key);
    if (raw == null || raw.isEmpty) return;
    final list = (jsonDecode(raw) as List).map((e) => EventModel.fromJson(e)).toList();
    list.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    events.assignAll(list);
  }

  void _persist() => _box.write(_key, jsonEncode(events.map((e) => e.toJson()).toList()));

  void setDate(DateTime date) => selectedDate.value = date;

  void addEvent() {
    if (titleController.text.trim().isEmpty || selectedDate.value == null) {
      Get.snackbar('Missing info', 'Please enter a title and pick a date');
      return;
    }
    events.add(EventModel(id: const Uuid().v4(), title: titleController.text.trim(), targetDate: selectedDate.value!));
    events.sort((a, b) => a.targetDate.compareTo(b.targetDate));
    titleController.clear();
    selectedDate.value = null;
    _persist();
  }

  void deleteEvent(String id) {
    events.removeWhere((e) => e.id == id);
    _persist();
  }

  Duration remaining(EventModel event) {
    final diff = event.targetDate.difference(now.value);
    return diff.isNegative ? Duration.zero : diff;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    titleController.dispose();
    super.onClose();
  }
}

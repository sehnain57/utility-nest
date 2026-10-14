import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CityTime {
  final String city;
  final double utcOffset; // hours relative to UTC

  CityTime({required this.city, required this.utcOffset});
}

class WorldClockController extends GetxController {
  final _box = GetStorage();
  static const _key = 'world_clock_cities';

  final now = DateTime.now().obs;
  Timer? _ticker;

  // A representative static list of cities with fixed standard-time UTC offsets.
  // (Simplified: does not auto-adjust for daylight saving time.)
  final Map<String, double> allCities = {
    'London': 0,
    'New York': -5,
    'Los Angeles': -8,
    'Karachi': 5,
    'New Delhi': 5.5,
    'Dubai': 4,
    'Tokyo': 9,
    'Sydney': 10,
    'Paris': 1,
    'Berlin': 1,
    'Moscow': 3,
    'Beijing': 8,
    'Singapore': 8,
    'Toronto': -5,
    'Riyadh': 3,
    'Cairo': 2,
  };

  final selectedCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read<List>(_key);
    selectedCities.assignAll(saved?.cast<String>() ?? ['London', 'New York', 'Karachi', 'Tokyo']);
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => now.value = DateTime.now());
  }

  void addCity(String city) {
    if (!selectedCities.contains(city)) {
      selectedCities.add(city);
      _persist();
    }
  }

  void removeCity(String city) {
    selectedCities.remove(city);
    _persist();
  }

  void _persist() => _box.write(_key, selectedCities);

  DateTime timeFor(String city) {
    final offset = allCities[city] ?? 0;
    final utcNow = now.value.toUtc();
    return utcNow.add(Duration(minutes: (offset * 60).round()));
  }

  String formattedOffset(String city) {
    final offset = allCities[city] ?? 0;
    final sign = offset >= 0 ? '+' : '-';
    final abs = offset.abs();
    final h = abs.truncate();
    final m = ((abs - h) * 60).round();
    return 'UTC$sign$h${m > 0 ? ':${m.toString().padLeft(2, '0')}' : ''}';
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class WaterTrackerController extends GetxController {
  final _box = GetStorage();
  static const _intakeKey = 'water_intake_ml';
  static const _dateKey = 'water_intake_date';
  static const _goalKey = 'water_goal_ml';

  final currentIntake = 0.obs;
  final dailyGoal = 2000.obs;

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    dailyGoal.value = _box.read(_goalKey) ?? 2000;
    final savedDate = _box.read(_dateKey);
    if (savedDate == _today) {
      currentIntake.value = _box.read(_intakeKey) ?? 0;
    } else {
      currentIntake.value = 0;
      _persist();
    }
  }

  void _persist() {
    _box.write(_intakeKey, currentIntake.value);
    _box.write(_dateKey, _today);
    _box.write(_goalKey, dailyGoal.value);
  }

  void addWater(int ml) {
    currentIntake.value += ml;
    _persist();
  }

  void reset() {
    currentIntake.value = 0;
    _persist();
  }

  void setGoal(int ml) {
    dailyGoal.value = ml;
    _persist();
  }

  double get progress => (currentIntake.value / dailyGoal.value).clamp(0.0, 1.0);
}

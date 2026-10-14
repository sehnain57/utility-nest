class HabitModel {
  final String id;
  String name;
  List<String> completedDates; // ISO date strings (yyyy-MM-dd)

  HabitModel({required this.id, required this.name, List<String>? completedDates})
      : completedDates = completedDates ?? [];

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'completedDates': completedDates};

  factory HabitModel.fromJson(Map<String, dynamic> json) => HabitModel(
        id: json['id'],
        name: json['name'] ?? '',
        completedDates: (json['completedDates'] as List?)?.cast<String>() ?? [],
      );
}

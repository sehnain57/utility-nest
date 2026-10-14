class EventModel {
  final String id;
  String title;
  DateTime targetDate;

  EventModel({required this.id, required this.title, required this.targetDate});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'targetDate': targetDate.toIso8601String()};

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'],
        title: json['title'] ?? '',
        targetDate: DateTime.tryParse(json['targetDate'] ?? '') ?? DateTime.now(),
      );
}

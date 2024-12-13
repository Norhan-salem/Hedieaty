import '../../domain/enums/EventCategory.dart';

class Event {
  int id;
  String name;
  String date;
  String location;
  String description;
  int category;
  String userId;
  bool isDeleted;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.description,
    required this.category,
    required this.userId,
    this.isDeleted = false,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      location: map['location'],
      description: map['description'],
      category: map['category'],
      userId: map['user_id'],
      isDeleted: map['isDeleted'] == 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'location': location,
      'description': description,
      'category': category,
      'user_id': userId,
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  EventCategory get eventCategory => EventCategory.values[category];

  set eventCategory(EventCategory category) {
    this.category = category.index;
  }
}

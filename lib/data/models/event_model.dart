import 'gift_model.dart';

class Event {
  final String name;
  final String category;
  final String status;
  final String description;
  final String location;
  final DateTime date;
  List<Gift>? gifts;

  Event({
    required this.name,
    required this.category,
    required this.status,
    required this.description,
    required this.location,
    required this.date,
    this.gifts,
  });
}

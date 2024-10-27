import 'event_model.dart';

class User {
  final String userName;
  final String email;
  final String phoneNumber;
  final List<Event> createdEvents;
  String? profileImageURL;

  User({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.createdEvents,
    this.profileImageURL
  });
}


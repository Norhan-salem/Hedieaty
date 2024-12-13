import 'package:hedieaty_flutter_application/data/repositories/event_repository.dart';

import '../../domain/enums/EventCategory.dart';
import '../../domain/enums/EventStatus.dart';
import '../models/event_model.dart';

EventStatus getEventStatus(Event event) {
  final currentDate = DateTime.now();
  final eventDate = DateTime.parse(event.date);

  if (eventDate.isBefore(currentDate)) {
    return EventStatus.past;
  } else if (eventDate.isAfter(currentDate)) {
    return EventStatus.upcoming;
  } else {
    return EventStatus.current;
  }
}

String mapEventStatusToString(EventStatus status) {
  switch (status) {
    case EventStatus.past:
      return 'Past';
    case EventStatus.upcoming:
      return 'Upcoming';
    case EventStatus.current:
      return 'Current';
    default:
      return 'Unknown';
  }
}

Future<int> countUpcomingEvents(String userId) async {
  List<Event> events = await EventRepository().fetchUserEvents(userId);
  int upcomingEventsCount = events.where((event) => getEventStatus(event) == EventStatus.upcoming).length;
  return upcomingEventsCount;
}

String mapEventCategoryToString(EventCategory category){
  return category.name[0].toUpperCase() + category.name.substring(1);
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/gifts_list_screen.dart';
import '../../data/models/event_model.dart';
import 'event_tile.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> events = [
    Event(name: 'Birthday Party', category: 'Celebration', status: 'Upcoming'),
    Event(name: 'Meeting', category: 'Work', status: 'Current'),
    Event(name: 'Concert', category: 'Entertainment', status: 'Past')
  ];

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventTile(
          event: event,
          onDelete: () {
            // Implement delete functionality
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                // will handle fetching the the gift list by event id later
                builder: (context) => GiftsListScreen(),
              ),
            );
          },
        );
      },
    );
  }
}

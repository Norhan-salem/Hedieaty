import 'package:flutter/material.dart';
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
    Event(name: 'Concert', category: 'Entertainment', status: 'Past'),
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
        return EventTile(
          event: events[index],
          onDelete: () => _deleteEvent(index),
        );
      },
    );
  }
}

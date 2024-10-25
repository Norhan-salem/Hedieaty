import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/gifts_list_screen.dart';

import '../../data/models/event_model.dart';
import '../screens/add_edit_event_screen.dart';
import 'event_tile.dart';

class EventList extends StatefulWidget {
  final List<Event> events;
  final Function(Event) onEventAdded;

  const EventList(
      {super.key, required this.events, required this.onEventAdded});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  void _deleteEvent(int index) {
    setState(() {
      widget.events.removeAt(index);
    });
  }

  void _updateEvent(int index, Event updatedEvent) {
    setState(() {
      widget.events[index] = updatedEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (context, index) {
        final event = widget.events[index];
        return EventTile(
          event: event,
          onDelete: () {
            // Implement delete functionality
            _deleteEvent(index);
          },
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftsListScreen(),
              ),
            );
          },
          onEdit: () {
            Navigator.push<Event>(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventScreen(event: event),
              ),
            ).then((updatedEvent) {
              if (updatedEvent != null) {
                _updateEvent(index, updatedEvent);
              }
            });
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/gifts_list_screen.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';
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
  final EventRepository _eventRepository = EventRepository();

  Future<void> _deleteEvent(int index) async {
    try {
      final eventId = widget.events[index].id;
      if (eventId != null) {
        await _eventRepository.deleteEvent(eventId);
        setState(() {
          widget.events.removeAt(index); // Remove event from the list
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event deleted successfully!')),
        );
      } else {
        throw Exception('Invalid event ID.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event: $e')),
      );
    }
  }

  Future<void> _updateEvent(int index, Event updatedEvent) async {
    try {
      final eventId = widget.events[index].id;
      if (eventId != null) {
        final updatedFields = updatedEvent.toMap();
        updatedFields.remove('id'); // Ensure 'id' is not updated
        await _eventRepository.updateEvent(eventId, updatedFields);

        setState(() {
          widget.events[index] = updatedEvent; // Update event in the list
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event updated successfully!')),
        );
      } else {
        throw Exception('Invalid event ID.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event: $e')),
      );
    }
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
            _deleteEvent(index); // Handle delete
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
                _updateEvent(index, updatedEvent); // Handle update
              }
            });
          },
        );
      },
    );
  }
}

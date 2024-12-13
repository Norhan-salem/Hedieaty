import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';
import '../screens/friend_gift_list_screen.dart';
import 'friend_event_tile.dart';

class FriendEventList extends StatelessWidget {
  final List<Event> events;

  FriendEventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return FriendEventTile(
          event: events[index],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FriendGiftsListScreen(event: events[index]),
            ),
          ),
        );
      },
    );
  }
}

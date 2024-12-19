import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        return Animate(
          child: FriendEventTile(
            event: events[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FriendGiftsListScreen(event: events[index]),
              ),
            ),
          )
        ).slide(begin: Offset(0, 6), end: Offset.zero, duration: 400.ms);
      },
    );
  }
}

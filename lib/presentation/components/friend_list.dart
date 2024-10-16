import 'package:flutter/material.dart';
import 'friend_tile.dart';

class FriendList extends StatelessWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final friends = [
      Friend(
          name: 'Friend1',
          profilePic: 'assets/images/profile_mock.png',
          upcomingEvents: 1),
      Friend(
          name: 'Friend2',
          profilePic: 'assets/images/profile_mock.png',
          upcomingEvents: 0)
    ];

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendTile(friend: friends[index]);
      },
    );
  }
}

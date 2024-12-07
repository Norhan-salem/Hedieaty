import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/friend_repository.dart';
import 'friend_tile.dart';

class FriendList extends StatelessWidget {
  const FriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building FriendList widget...");

    return FutureBuilder<User?>(
      future: UserRepository().fetchCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Fetching current user... Waiting for data.");
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print("Error fetching current user: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          User? currentUser = snapshot.data;
          print("Current user fetched: ${currentUser?.id}");

          if (currentUser == null) {
            print("No current user found.");
            return Center(child: Text('No user found.'));
          }

          print("Fetching friends for user ID: ${currentUser.id}");
          return FutureBuilder<List<User>>(
            future: FriendRepository().fetchLoggedInUserFriends(currentUser.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("Fetching friends... Waiting for data.");
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("Error fetching friends: ${snapshot.error}");
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  print("No friends found.");
                  return Center(child: Text('No friends found.'));
                }

                List<User> friends = snapshot.data!;
                print("Found ${friends.length} friends.");
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    print("Building FriendTile for friend at index: $index");
                    return FriendTile(friend: friends[index]);
                  },
                );
              } else {
                print("No friends available.");
                return Center(child: Text('No friends available.'));
              }
            },
          );
        } else {
          print("No current user found.");
          return Center(child: Text('No current user found.'));
        }
      },
    );
  }
}


import 'package:flutter/material.dart';

import '../../presentation/components/friend_tile.dart';
import '../models/user_model.dart';
import '../repositories/friend_repository.dart';

class FriendSearchDelegate extends SearchDelegate<User?> {
  @override
  String get searchFieldLabel => 'Search for friends';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: FriendRepository().searchForFriend(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No friends found.'));
        } else if (snapshot.hasData) {
          final results = snapshot.data!;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              return FriendTile(friend: results[index]);
            },
          );
        } else {
          return Center(child: Text('Start searching for friends!'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Enter a name, email, or phone number to search.'),
    );
  }
}

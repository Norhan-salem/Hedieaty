import 'package:flutter/material.dart';
import '../widgets/add_friend_button.dart';
import '../widgets/create_event_button.dart';
import '../widgets/friend_list.dart';
import '../widgets/custom_app_bar.dart';
import 'events_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Friends',
        actionIcon: Icons.search,
        onActionPressed: () {
          //To-Do implement search functionality
        },
      ),
      body: Column(
        children: [
          SizedBox(height: appBarPadding),
          CreateEventButton(
            buttonText: 'Create Your Own Event',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventListPage()),
              );
            },
          ),
          SizedBox(height: appBarPadding),
          Expanded(
            child: FriendList(),
          ),
        ],
      ),
      floatingActionButton: AddFriendButton(),
    );
  }
}

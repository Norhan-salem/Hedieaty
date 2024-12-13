import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';

import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/event_model.dart';
import '../components/friend_event_list.dart';
import '../widgets/custom_app_bar.dart';

class FriendEventsListScreen extends StatelessWidget {
  final List<Event> friendEvents;
  final String friendName;

  FriendEventsListScreen({Key? key, required this.friendEvents, required this.friendName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Event>> sortedEventsNotifier =
        ValueNotifier<List<Event>>(friendEvents);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: "$friendName's Events",
        actionIcon: Icons.sort,
        onActionPressed: () {
          showSortingMenu(context, sortedEventsNotifier);
        },
      ),
      body: Stack(
        children: [
          BackgroundContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: appBarPadding),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: sortedEventsNotifier,
                      builder: (context, sortedEvents, child) {
                        return FriendEventList(events: sortedEvents);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

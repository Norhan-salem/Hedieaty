import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/event_list.dart';

class EventsListScreen extends StatelessWidget {
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Events',
        actionIcon: Icons.sort,
        onActionPressed: () {
          // To-Do: display mini menu of sorting options
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
                  CreateEventButton(
                    buttonText: 'Add New Event',
                    onPressed: () {},
                  ),
                  SizedBox(height: appBarPadding),
                  Expanded(
                    child: EventList(),
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

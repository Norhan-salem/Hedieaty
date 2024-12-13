import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/create_event_button.dart';
import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/event_model.dart';
import '../components/event_list.dart';
import '../widgets/custom_app_bar.dart';
import 'add_edit_event_screen.dart';

class EventsListScreen extends StatefulWidget {
  final String userId;
  final List<Event> initialEvents;

  const EventsListScreen({
    Key? key,
    required this.userId,
    required this.initialEvents,
  }) : super(key: key);

  @override
  _EventsListScreenState createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen> {
  late ValueNotifier<List<Event>> sortedMyEventsNotifier;

  @override
  void initState() {
    super.initState();
    sortedMyEventsNotifier = ValueNotifier<List<Event>>(widget.initialEvents);
  }

  @override
  void dispose() {
    sortedMyEventsNotifier.dispose();
    super.dispose();
  }

  void _addEvent(Event newEvent) {
    sortedMyEventsNotifier.value = [...sortedMyEventsNotifier.value, newEvent];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Events',
        actionIcon: Icons.sort,
        onActionPressed: () {
          showSortingMenu(context, sortedMyEventsNotifier);
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
                    onPressed: () {
                      Navigator.push<Event>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEventScreen(),
                        ),
                      ).then((newEvent) {
                        if (newEvent != null) {
                          _addEvent(newEvent);
                        }
                      });
                    },
                  ),
                  SizedBox(height: appBarPadding),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: sortedMyEventsNotifier,
                      builder: (context, sortedMyEvents, child) {
                        return EventList(
                          events: sortedMyEvents,
                          onEventAdded: (Event newEvent) {
                            _addEvent(newEvent);
                          },
                        );
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

import 'package:flutter/material.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/create_event_button.dart';
import '../widgets/gift_list.dart';

class GiftsListScreen extends StatelessWidget {
  const GiftsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double appBarPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Gifts',
        actionIcon: Icons.sort,
        onActionPressed: () {
          // To-Do: display mini menu of sorting options
        },
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: appBarPadding),
              CreateEventButton(
                buttonText: 'Add New Gift',
                onPressed: () {
                  // To-Do: Navigate to Add Gift page or open dialog
                },
              ),
              SizedBox(height: appBarPadding),
              Expanded(
                child: GiftList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

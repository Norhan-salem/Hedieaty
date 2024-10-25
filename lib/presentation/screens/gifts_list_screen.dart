import 'package:flutter/material.dart';
import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/gift_model.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/create_event_button.dart';
import '../components/gift_list.dart';

class GiftsListScreen extends StatelessWidget {
  GiftsListScreen({Key? key}) : super(key: key);

  final List<Gift> gifts = [
    Gift(name: 'Smartphone', category: 'Electronics', status: 'available'),
    Gift(name: 'Book', category: 'Education', status: 'pledged'),
    Gift(name: 'Headphones', category: 'Electronics', status: 'available'),
  ];

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Gift>> sortedMyGiftsNotifier =
    ValueNotifier<List<Gift>>(gifts);
    double appBarPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Gifts',
        actionIcon: Icons.sort,
        onActionPressed: () {
          showSortingMenu(context, sortedMyGiftsNotifier);
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
                child: ValueListenableBuilder<List<Gift>>(
                    valueListenable: sortedMyGiftsNotifier,
                    builder: (context, sortedGifts, child) {
                      return GiftList(myGifts: sortedGifts);
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

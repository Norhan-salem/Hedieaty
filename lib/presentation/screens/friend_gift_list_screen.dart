import 'package:flutter/material.dart';

import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/gift_model.dart';
import '../components/friend_gift_list.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_app_bar.dart';

class FriendGiftsListScreen extends StatelessWidget {
  final String eventName;

  FriendGiftsListScreen({Key? key, required this.eventName}) : super(key: key);

  final List<Gift> gifts = [
    Gift(
        name: 'Smartphone',
        category: 'Electronics',
        status: 'Available',
        price: 30.0,
        description: ''),
    Gift(
        name: 'Book',
        category: 'Education',
        status: 'Pledged',
        price: 30.0,
        description: ''),
    Gift(
        name: 'Headphones',
        category: 'Electronics',
        status: 'Available',
        price: 30.0,
        description: ''),
  ];

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Gift>> sortedGiftsNotifier =
        ValueNotifier<List<Gift>>(gifts);
    double appBarPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: "$eventName's Gifts",
        actionIcon: Icons.sort,
        onActionPressed: () {
          showSortingMenu(context, sortedGiftsNotifier);
        },
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Column(
            children: [
              SizedBox(height: appBarPadding),
              Expanded(
                child: ValueListenableBuilder<List<Gift>>(
                  valueListenable: sortedGiftsNotifier,
                  builder: (context, sortedGifts, child) {
                    return FriendGiftList(friendGifts: sortedGifts);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

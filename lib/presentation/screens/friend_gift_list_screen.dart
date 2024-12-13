import 'package:flutter/material.dart';

import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/event_model.dart';
import '../../data/models/gift_model.dart';
import '../../data/repositories/gift_repository.dart';
import '../components/friend_gift_list.dart';
import '../widgets/background_image_container.dart';
import '../widgets/custom_app_bar.dart';

class FriendGiftsListScreen extends StatelessWidget {
  final Event event;

  FriendGiftsListScreen({Key? key, required this.event}) : super(key: key);

  Future<List<Gift>> _fetchGifts(int eventId) async {
    return await GiftRepository().fetchGiftsByEventId(eventId);
  }

  @override
  Widget build(BuildContext context) {
    double appBarPadding = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: "${event.name}'s Gifts",
        actionIcon: Icons.sort,
        onActionPressed: () {
          showSortingMenu(context, ValueNotifier<List<Gift>>([]));
        },
      ),
      body: BackgroundContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            children: [
              SizedBox(height: appBarPadding),
              Expanded(
                child: FutureBuilder<List<Gift>>(
                  future: _fetchGifts(event.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load gifts.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No gifts available.'));
                    } else {
                      final sortedGiftsNotifier = ValueNotifier<List<Gift>>(snapshot.data!);

                      return ValueListenableBuilder<List<Gift>>(
                        valueListenable: sortedGiftsNotifier,
                        builder: (context, sortedGifts, child) {
                          return FriendGiftList(friendGifts: sortedGifts);
                        },
                      );
                    }
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


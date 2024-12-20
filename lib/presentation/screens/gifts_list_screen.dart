import 'package:flutter/material.dart';

import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/gift_model.dart';
import '../components/gift_list.dart';
import '../widgets/background_image_container.dart';
import '../widgets/create_event_button.dart';
import '../widgets/custom_app_bar.dart';
import 'add_edit_gift_screen.dart';

class GiftsListScreen extends StatefulWidget {
  final int eventId;
  final List<Gift> gifts;

  GiftsListScreen({Key? key, required this.gifts, required this.eventId}) : super(key: key);

  @override
  _GiftsListScreenState createState() => _GiftsListScreenState();
}

class _GiftsListScreenState extends State<GiftsListScreen> {
  late List<Gift> gifts;

  @override
  void initState() {
    super.initState();
    gifts = widget.gifts;
  }

  void _addOrUpdateGift(Gift newGift) {
    setState(() {
      gifts = List.from(gifts)
        ..removeWhere((gift) => gift.id == newGift.id)
        ..add(newGift);
    });
  }

  Future<void> _navigateToAddGiftScreen() async {
    final newGift = await Navigator.push<Gift>(
      context,
      MaterialPageRoute(
        builder: (context) => AddGiftScreen(eventId: widget.eventId),
      ),
    );

    if (newGift != null) {
      _addOrUpdateGift(newGift);
    }
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<List<Gift>> sortedMyGiftsNotifier = ValueNotifier<List<Gift>>(gifts);

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
                onPressed: _navigateToAddGiftScreen,
              ),
              SizedBox(height: appBarPadding),
              Expanded(
                child: ValueListenableBuilder<List<Gift>>(
                  valueListenable: sortedMyGiftsNotifier,
                  builder: (context, sortedMyGifts, child) {
                    return GiftList(
                      eventId: widget.eventId,
                      myGifts: sortedMyGifts,
                      onGiftAdded: _addOrUpdateGift,
                    );
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


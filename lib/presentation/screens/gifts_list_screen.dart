import 'package:flutter/material.dart';

import '../../core/utils/sorting_menu_utils.dart';
import '../../data/models/gift_model.dart';
import '../components/gift_list.dart';
import '../widgets/background_image_container.dart';
import '../widgets/create_event_button.dart';
import '../widgets/custom_app_bar.dart';
import 'add_edit_gift_screen.dart';

class GiftsListScreen extends StatefulWidget {
  const GiftsListScreen({Key? key}) : super(key: key);

  @override
  _GiftsListScreenState createState() => _GiftsListScreenState();
}

class _GiftsListScreenState extends State<GiftsListScreen> {
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

  ValueNotifier<List<Gift>> sortedMyGiftsNotifier =
      ValueNotifier<List<Gift>>([]);

  @override
  void initState() {
    super.initState();
    sortedMyGiftsNotifier.value = gifts;
  }

  void _addGift(Gift newGift) {
    setState(() {
      gifts.add(newGift);
      sortedMyGiftsNotifier.value = List.from(gifts);
    });
  }

  @override
  Widget build(BuildContext context) {

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
                  Navigator.push<Gift>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddGiftScreen(),
                    ),
                  ).then((newGift) {
                    if (newGift != null) {
                      _addGift(newGift);
                    }
                  });
                },
              ),
              SizedBox(height: appBarPadding),
              Expanded(
                child: ValueListenableBuilder<List<Gift>>(
                    valueListenable: sortedMyGiftsNotifier,
                    builder: (context, sortedMyGifts, child) {
                      return GiftList(
                        myGifts: sortedMyGifts,
                        onGiftAdded: (Gift newGift) {
                          _addGift(newGift);
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/screens/profile_screen.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/event_model.dart';
import '../../data/models/gift_model.dart';
import '../../data/models/user_model.dart';
import '../components/add_friend_button.dart';
import '../components/friend_list.dart';
import '../widgets/create_event_button.dart';
import '../widgets/custom_app_bar.dart';
import 'events_list_screen.dart';

final User user = User(
  userName: 'John Doe',
  email: 'john.doe@example.com',
  phoneNumber: '123-456-7890',
  profileImageURL: 'assets/images/profile_mock.png',
  createdEvents: [
    Event(
      name: 'Birthday Party',
      category: 'Celebration',
      status: 'Upcoming',
      description: 'John’s 30th birthday celebration.',
      location: '123 Party St, Hometown',
      date: DateTime(2024, 12, 20),
      gifts: [
        Gift(
          name: 'Gift Card',
          category: 'Vouchers',
          status: 'available',
          price: 50.0,
          description: 'A 50 Dollar gift card for any store.',
        ),
        Gift(
          name: 'Bluetooth Speaker',
          category: 'Electronics',
          status: 'pledged',
          price: 120.0,
          description: 'Portable Bluetooth speaker with high-quality sound.',
        ),
      ],
    ),
    Event(
      name: 'Christmas Party',
      category: 'Holiday',
      status: 'Past',
      description: 'Annual family Christmas gathering.',
      location: '456 Celebration Ave, Hometown',
      date: DateTime(2023, 12, 25),
      gifts: [
        Gift(
          name: 'Scented Candle Set',
          category: 'Home Decor',
          status: 'available',
          price: 30.0,
          description: 'A set of aromatic candles.',
          imageURL: 'assets/images/candles.png',
        ),
      ],
    ),
  ],
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Friends',
        actionIcon: Icons.search,
        onActionPressed: () {
          // To-Do: implement search functionality
        },
        leadingIcon: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                        user: user,
                        onEditProfile: () {},
                        onManageNotifications: () {},
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.darkTeal,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: ColorPalette.darkTeal, width: 1),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile_mock.png'),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          BackgroundContainer(
            child: Column(
              children: [
                SizedBox(height: appBarPadding),
                CreateEventButton(
                  buttonText: 'Create Your Own Event',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventsListScreen()),
                    );
                  },
                ),
                SizedBox(height: appBarPadding),
                Expanded(
                  child: FriendList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AddFriendButton(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/repositories/user_repository.dart';
import 'package:hedieaty_flutter_application/presentation/screens/profile_screen.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';

import '../../core/constants/color_palette.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/services/friends_search.dart';
import '../components/add_friend_button.dart';
import '../components/friend_list.dart';
import '../components/notif_button.dart';
import '../widgets/create_event_button.dart';
import '../widgets/custom_app_bar.dart';
import 'events_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentUserId;
  String? _profileImgPath;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final currentUser = await UserRepository().fetchCurrentUser();
    setState(() {
      _currentUserId = currentUser?.id;
      _profileImgPath = currentUser?.profileImagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarPadding = screenHeight * 0.02;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Friends',
        actionIcon: Icons.search,
        onActionPressed: () {
          showSearch(
            context: context,
            delegate: FriendSearchDelegate(),
          );
        },
        leadingIcon: GestureDetector(
          onTap: () {
            if (_currentUserId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userId: _currentUserId!,
                    onEditProfile: () {},
                    onManageNotifications: () {},
                  ),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorPalette.darkTeal,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: ColorPalette.darkTeal, width: 1),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _profileImgPath != null
                  ? NetworkImage(_profileImgPath!)
                  : AssetImage('assets/images/profile_mock.png')
                      as ImageProvider,
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
                  onPressed: () async {
                    if (_currentUserId != null) {
                      final userEvents = await EventRepository()
                          .fetchUserEvents(_currentUserId!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventsListScreen(
                            userId: _currentUserId!,
                            initialEvents: userEvents,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: appBarPadding),
                Expanded(
                  child: FriendList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: NotificationButton(),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: AddFriendButton(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/tile_decoration.dart';
import 'package:hedieaty_flutter_application/presentation/screens/friend_events_list_screen.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/friend_model.dart';

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      child: Container(
        decoration: TileDecoration.tileBorder(),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.001,
          ),
          leading: CircleAvatar(
            radius: screenWidth * 0.06,
            backgroundImage: AssetImage(friend.profilePic),
          ),
          title: Text(
            friend.name,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: ColorPalette.darkTeal,
            ),
          ),
          subtitle: Text(
            friend.upcomingEvents > 0
                ? 'Upcoming Events: ${friend.upcomingEvents}'
                : 'No Upcoming Events',
            style: TextStyle(
              color: friend.upcomingEvents > 0
                  ? ColorPalette.darkPink
                  : Colors.grey,
              fontSize: screenWidth * 0.033,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: friend.upcomingEvents > 0
              ? _buildEventIndicator(screenWidth)
              : null,
          onTap: () {
            // To-Do: Navigate to friend's gift list screen
            Navigator.push(
              context,
              MaterialPageRoute(
                // will handle fetching the the gift list by event id later
                builder: (context) =>
                    FriendEventsListScreen(friendName: friend.name),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEventIndicator(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorPalette.darkPink,
        shape: BoxShape.circle,
      ),
      child: Text(
        friend.upcomingEvents.toString(),
        style: TextStyle(
          color: ColorPalette.eggShell,
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

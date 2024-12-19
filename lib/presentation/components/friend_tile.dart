import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/tile_decoration.dart';
import 'package:hedieaty_flutter_application/data/repositories/event_repository.dart';
import 'package:hedieaty_flutter_application/presentation/screens/friend_events_list_screen.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/user_model.dart';
import '../../data/services/event_service.dart';


class FriendTile extends StatelessWidget {
  final User friend;

  FriendTile({Key? key, required this.friend}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.05,
        vertical: isLandscape ? screenHeight * 0.005 : screenHeight * 0.01,
      ),
      child: Container(
        decoration: TileDecoration.tileBorder(),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: isLandscape ? screenWidth * 0.02 : screenWidth * 0.04,
            vertical: isLandscape ? screenHeight * 0.005 : screenHeight * 0.001,
          ),
          leading: CircleAvatar(
            radius: isLandscape ? screenWidth * 0.04 : screenWidth * 0.06,
            backgroundImage: NetworkImage(friend.profileImagePath),
          ),
          title: Text(
            friend.username,
            style: TextStyle(
              fontSize: isLandscape ? screenWidth * 0.025 : screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              color: ColorPalette.darkTeal,
            ),
          ),
          subtitle: FutureBuilder<int>(
            future: countUpcomingEvents(friend.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isLandscape
                        ? screenWidth * 0.025
                        : screenWidth * 0.033,
                    fontFamily: 'Poppins',
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isLandscape
                        ? screenWidth * 0.025
                        : screenWidth * 0.033,
                    fontFamily: 'Poppins',
                  ),
                );
              } else if (snapshot.hasData) {
                int upcomingEvents = snapshot.data!;
                return Text(
                  upcomingEvents > 0
                      ? 'Upcoming Events: $upcomingEvents'
                      : 'No Upcoming Events',
                  style: TextStyle(
                    color: upcomingEvents > 0
                        ? ColorPalette.darkPink
                        : Colors.grey,
                    fontSize: isLandscape
                        ? screenWidth * 0.02
                        : screenWidth * 0.033,
                    fontFamily: 'Poppins',
                  ),
                );
              } else {
                return Text(
                  'No Upcoming Events',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isLandscape
                        ? screenWidth * 0.02
                        : screenWidth * 0.033,
                    fontFamily: 'Poppins',
                  ),
                );
              }
            },
          ),
          trailing: FutureBuilder<int>(
            future: countUpcomingEvents(friend.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return SizedBox.shrink();
              }
              int upcomingEvents = snapshot.data!;
              return upcomingEvents > 0
                  ? _buildEventIndicator(
                isLandscape ? screenWidth * 0.5 : screenWidth,
                upcomingEvents,
              )
                  : SizedBox.shrink();
            },
          ),
          onTap: () => _onTap(context),
        ),
      ),
    );
  }

  Widget _buildEventIndicator(double screenWidth, int upcomingEvents) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorPalette.darkPink,
        shape: BoxShape.circle,
      ),
      child: Text(
        upcomingEvents.toString(),
        style: TextStyle(
          color: ColorPalette.eggShell,
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      final friendEvents =
      await EventRepository().fetchUserEvents(friend.id);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FriendEventsListScreen(
            friendEvents: friendEvents,
            friendName: friend.username,
          ),
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch events: $error'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}


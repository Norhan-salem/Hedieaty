import 'package:flutter/material.dart';
import '../../core/utils/tile_decoration.dart';
import '../../data/models/event_model.dart';
import '../../core/constants/color_palette.dart';
import '../../data/services/event_service.dart';
import '../../domain/enums/EventCategory.dart';

class FriendEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const FriendEventTile({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: isLandscape ? screenHeight * 0.015 : screenHeight * 0.008,
          horizontal: isLandscape ? screenWidth * 0.15 : screenWidth * 0.05,
        ),
        decoration: TileDecoration.tileBorder(),
        child: ListTile(
          title: Text(
            event.name,
            style: TextStyle(
              color: ColorPalette.darkTeal,
              fontFamily: 'Poppins',
            ),
          ),
          subtitle: Text(
            '${mapEventCategoryToString(EventCategory.values[event.category])} - ${formatDate(event.date)}',
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}

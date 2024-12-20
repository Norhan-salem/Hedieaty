import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/tile_decoration.dart';
import '../../data/models/event_model.dart';
import '../../data/services/event_service.dart';
import '../../domain/enums/EventCategory.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const EventTile({
    Key? key,
    required this.event,
    required this.onDelete,
    required this.onTap,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    final eventStatus = getEventStatus(event);

    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: isLandscape ? screenWidth * 0.7 : double.infinity,
          margin: EdgeInsets.symmetric(
            vertical: isLandscape ? screenHeight * 0.03 : screenHeight * 0.008,
            horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.05,
          ),
          decoration: TileDecoration.tileBorder(),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.04,
              vertical: isLandscape ? screenHeight * 0.009 : screenHeight * 0.001,
            ),
            title: Text(
              event.name,
              style: TextStyle(
                fontSize: isLandscape ? screenWidth * 0.025 : screenWidth * 0.04,
                color: ColorPalette.darkTeal,
                fontFamily: 'Poppins',
              ),
            ),
            subtitle: Text(
              '${mapEventCategoryToString(EventCategory.values[event.category])} - ${mapEventStatusToString(eventStatus)}',
              style: TextStyle(
                fontSize: isLandscape ? screenWidth * 0.02 : screenWidth * 0.035,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  iconSize: isLandscape ? screenWidth * 0.04 : screenWidth * 0.07,
                  icon: Icon(Icons.edit_outlined, color: ColorPalette.darkTeal),
                  onPressed: onEdit,
                ),
                IconButton(
                  iconSize: isLandscape ? screenWidth * 0.04 : screenWidth * 0.07,
                  icon: Icon(Icons.delete_outline, color: ColorPalette.darkTeal),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

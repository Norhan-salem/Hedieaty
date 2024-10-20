import 'package:flutter/material.dart';
import '../../core/utils/tile_decoration.dart';
import '../../data/models/event_model.dart';
import '../../core/constants/color_palette.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const EventTile({
    Key? key,
    required this.event,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.008, horizontal: screenWidth * 0.05),
        decoration: TileDecoration.tileBorder(),
        child: ListTile(
          title: Text(
            event.name,
            style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
          ),
          subtitle: Text(
            '${event.category} - ${event.status}',
            style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
          ),
          trailing: IconButton(
            iconSize: screenWidth * 0.1,
            icon: Icon(Icons.delete_outline, color: ColorPalette.darkTeal),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}


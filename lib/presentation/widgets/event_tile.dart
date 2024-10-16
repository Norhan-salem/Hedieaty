import 'package:flutter/material.dart';
import '../../data/models/event_model.dart';
import '../../core/utils/color_palette.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;

  const EventTile({Key? key, required this.event, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, horizontal: screenWidth * 0.05),
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.darkTeal, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: ColorPalette.eggShell,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.darkTeal,
            offset: Offset(3, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        title: Text(event.name,
            style:
                TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins')),
        subtitle: Text('${event.category} - ${event.status}',
            style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
        trailing: IconButton(
          iconSize: screenWidth * 0.1,
          icon: Icon(Icons.delete_outline, color: ColorPalette.darkTeal),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

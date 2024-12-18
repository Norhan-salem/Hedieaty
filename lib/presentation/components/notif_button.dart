import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../screens/notif_screen.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonSize = screenWidth < screenHeight
        ? screenWidth * 0.2  // Portrait mode
        : screenHeight * 0.2; // Landscape mode

    double iconSize = buttonSize * 0.6;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.darkTeal,
            offset: Offset(2, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NotificationScreen(),
            ),
          );
        },
        backgroundColor: ColorPalette.darkCyan,
        child: Icon(
          Icons.notifications_none_outlined,
          size: iconSize,
          color: ColorPalette.eggShell,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(color: ColorPalette.darkTeal, width: 3),
        ),
      ),
    );
  }
}

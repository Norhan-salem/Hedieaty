import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';

class CreateEventButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CreateEventButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonHeight = screenWidth < screenHeight
        ? screenWidth * 0.15  // Portrait mode
        : screenHeight * 0.15; // Landscape mode

    double buttonWidth = screenWidth < screenHeight
        ? screenWidth * 0.7  // Portrait mode
        : screenWidth * 0.45; // Landscape mode

    double fontSize = screenWidth < screenHeight
    ? screenWidth * 0.048 : screenHeight * 0.06;

    return Container(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Poppins',
          ),
          backgroundColor: ColorPalette.darkCyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: ColorPalette.darkTeal,
              width: 3,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: TextStyle(color: ColorPalette.eggShell),
        ),
      ),
    );
  }
}

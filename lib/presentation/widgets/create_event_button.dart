import 'package:flutter/material.dart';
import '../../core/utils/color_palette.dart';

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

    return Container(
      height: screenHeight * 0.07,
      width: screenWidth * 0.7,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
            fontSize: screenWidth * 0.048,
            fontFamily: 'Poppins',
            color: ColorPalette.eggShell,
          ),
          backgroundColor: ColorPalette.darkCyan,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: ColorPalette.darkTeal,
              width: 2,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}

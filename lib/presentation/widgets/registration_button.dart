import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';
import '../../core/utils/tile_decoration.dart';

class RegistrationButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const RegistrationButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.065,
      width: screenWidth * 0.9,
      child: Container(
        decoration: TileDecoration.tileBorder(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
              fontSize: screenWidth * 0.05,
              fontFamily: 'Poppins',
            ),
            backgroundColor: ColorPalette.lightYellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
              color: ColorPalette.darkTeal,
            ),
          ),
        ),
      ),
    );
  }
}

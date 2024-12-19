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
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth = constraints.maxWidth * 1;
        double buttonHeight =
            constraints.maxHeight > 0 ? constraints.maxHeight * 0.065 : 50;

        return Center(
          child: SizedBox(
            width: buttonWidth.clamp(300, 400),
            height: buttonHeight.clamp(40, 53),
            child: Container(
              decoration: TileDecoration.tileBorder(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 24,
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
          ),
        );
      },
    );
  }
}

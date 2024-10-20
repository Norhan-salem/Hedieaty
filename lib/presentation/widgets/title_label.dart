import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';

class TitleLabel extends StatelessWidget {
  final String text;

  TitleLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;

    double fontSize = (orientation == Orientation.portrait)
        ? (screenSize.width < 600 ? 50 : 54) // Portrait
        : (screenSize.width < 600 ? 48 : 54); // Landscape

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Rowdies',
          fontSize: fontSize,
          color: ColorPalette.darkTeal,
        ),
      ),
    );
  }
}


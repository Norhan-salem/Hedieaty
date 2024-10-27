import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/tile_decoration.dart';

class GiftDetailsTile extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;

  const GiftDetailsTile(
      {Key? key, required this.text, this.height = 55, this.width = 300})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(screenWidth * 0.04),
        height: height,
        width: width,
        margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.008,
          horizontal: screenWidth * 0.05,
        ),
        decoration: TileDecoration.tileBorder(),
        child: Text(
          text,
          style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
        ));
  }
}

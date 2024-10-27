import 'package:flutter/material.dart';
import '../constants/color_palette.dart';

class TileDecoration {
  static BoxDecoration tileBorder() {
    return BoxDecoration(
      color: ColorPalette.eggShell,
      border: Border.all(color: ColorPalette.darkTeal, width: 2),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: ColorPalette.darkTeal,
          offset: Offset(2, 3),
          spreadRadius: 1,
        ),
      ],
    );
  }
}

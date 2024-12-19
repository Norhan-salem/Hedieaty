import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String? imageUrl;

  const CustomCircleAvatar({
    Key? key,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarRadius = screenWidth * 0.25;

    return Container(
      decoration: BoxDecoration(
        color: ColorPalette.darkTeal,
        borderRadius: BorderRadius.circular(avatarRadius),
        border: Border.all(color: ColorPalette.darkTeal, width: 2),
        boxShadow: [
          BoxShadow(
            color: ColorPalette.darkTeal.withOpacity(1),
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundImage: NetworkImage(imageUrl!),
      ),
    );
  }
}

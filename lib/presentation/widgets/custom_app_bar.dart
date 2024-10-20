import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double appBarHeight = screenHeight * 0.08;
    double fontSize = screenWidth * 0.07;
    double iconSize = screenWidth * 0.08;

    return Container(
      decoration: BoxDecoration(
        color: ColorPalette.lightYellow,
        border: Border(
          bottom: BorderSide(color: ColorPalette.darkTeal, width: 3),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (actionIcon != null && onActionPressed != null)
            IconButton(
              icon: Icon(
                actionIcon,
                size: iconSize,
              ),
              onPressed: onActionPressed,
            ),
        ],
        toolbarHeight: appBarHeight,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

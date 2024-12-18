import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final Widget? leadingIcon;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actionIcon,
    this.onActionPressed,
    this.leadingIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double appBarHeight = screenHeight * 0.08;

    double fontSize = screenWidth > screenHeight
        ? screenHeight * 0.07
        : screenWidth * 0.07;

    double iconSize = screenWidth > screenHeight
        ? screenHeight * 0.08
        : screenWidth * 0.09;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: ColorPalette.lightYellow,
        border: Border(
          bottom: BorderSide(color: ColorPalette.darkTeal, width: 3),
        ),
      ),
      child: AppBar(
        leading: leadingIcon,
        title: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
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


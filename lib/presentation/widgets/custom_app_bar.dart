import 'package:flutter/material.dart';
import '../../core/utils/color_palette.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double appBarHeight = screenHeight * 0.8;
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
          'Friends',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: iconSize,
            ),
            onPressed: () {
              // To-Do implement search functionality
            },
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

import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';

Future<void> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  Widget? content,
  List<Widget>? actions,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    },
  );
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final List<Widget>? actions;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    this.content,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.eggShell,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: ColorPalette.darkTeal, width: 3),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: ColorPalette.darkTeal,
          fontFamily: 'Poppins',
        ),
      ),
      content: content,
      actions: actions,
    );
  }
}

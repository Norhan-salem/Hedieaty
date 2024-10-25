import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/add_friend_dialog.dart';

import '../../core/constants/color_palette.dart';

void showManualFriendForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColorPalette.eggShell,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ColorPalette.darkTeal, width: 3),
        ),
        title: Text(
          'Add Friend Manually',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: ColorPalette.darkTeal,
          ),
        ),
        content: FriendFormDialog(),
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/add_friend_dialog.dart';
import '../../presentation/widgets/custom_alert_dialog.dart';

void showManualFriendForm(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        title: 'Add Friend Manually',
        content: FriendFormDialog(),
      );
    },
  );
}

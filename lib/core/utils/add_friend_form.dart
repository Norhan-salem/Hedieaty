import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/services/authentication_service.dart';
import 'package:hedieaty_flutter_application/presentation/components/add_friend_dialog.dart';
import '../../presentation/widgets/custom_alert_dialog.dart';

void showManualFriendForm(BuildContext context) async {
  final AuthService _authService = AuthService();
  try {
    final currentUser = await _authService.getCurrentUser();

    if (currentUser?.uid != null) {
      final currentUserId = currentUser!.uid;

      showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
            title: 'Add Friend Manually',
            content: FriendFormDialog(currentUserId: currentUserId),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No logged-in user found.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching user ID: $e')),
    );
  }
}


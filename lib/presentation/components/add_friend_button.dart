import 'package:flutter/material.dart';
import '../../core/constants/color_palette.dart';
import '../../core/utils/add_friend_form.dart';

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust button size based on both screen width and height
    double buttonSize = screenWidth < screenHeight
        ? screenWidth * 0.2  // Portrait mode
        : screenHeight * 0.2; // Landscape mode

    double iconSize = buttonSize * 0.6;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: ColorPalette.darkTeal,
            offset: Offset(2, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'add friend',
        onPressed: () {
          _showAddFriendOptions(context);
        },
        backgroundColor: ColorPalette.darkCyan,
        child: Icon(
          Icons.person_add_alt,
          size: iconSize,
          color: ColorPalette.eggShell,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(color: ColorPalette.darkTeal, width: 3),
        ),
      ),
    );
  }

  void _showAddFriendOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorPalette.eggShell,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: ColorPalette.darkTeal),
              title: Text(
                'Add Friend Manually',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.darkTeal,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                showManualFriendForm(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contacts, color: ColorPalette.darkTeal),
              title: Text(
                'Add From Contacts',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.darkTeal,
                ),
              ),
              onTap: () {
                // TODO: Implement contact list import
              },
            ),
          ],
        );
      },
    );
  }
}


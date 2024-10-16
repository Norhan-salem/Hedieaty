import 'package:flutter/material.dart';
import '../../core/utils/color_palette.dart';

class AddFriendButton extends StatelessWidget {
  const AddFriendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth * 0.2;
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
                // To-Do: Implement manual friend addition
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
                // To-Do: Implement contact list import
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import 'friend_email_input.dart';

class FriendFormDialog extends StatefulWidget {
  @override
  _FriendFormState createState() => _FriendFormState();
}

class _FriendFormState extends State<FriendFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String friendEmail = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FriendEmailInput(),
          SizedBox(height: 16),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: ColorPalette.darkPink,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              // TODO: Implement logic to add friend with `friendEmail`
              print('Friend Email: $friendEmail');
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorPalette.eggShell,
            backgroundColor: ColorPalette.darkCyan,
            side: BorderSide(color: ColorPalette.darkTeal, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text('Add', style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}

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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FriendEmailInput(onSaved: (value) {
              friendEmail = value ?? '';
            }),
            SizedBox(height: 16),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
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
        SizedBox.square(
          dimension: 10,
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              // TODO: Implement logic to add friend with `friendEmail`
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: ColorPalette.eggShell,
            backgroundColor: ColorPalette.darkCyan,
            side: BorderSide(color: ColorPalette.darkTeal, width: 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('Add', style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/registration_input_validation.dart';

import '../../core/constants/color_palette.dart';

void showManualFriendForm(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  String friendEmail = '';

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ColorPalette.eggShell,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Add Friend Manually',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: ColorPalette.darkTeal,
          ),
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Friend Email',
              labelStyle: TextStyle(color: ColorPalette.darkTeal),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.darkTeal),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ColorPalette.darkTeal),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email';
              }
              if (!RegistrationInputValidation.isEmailValid(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            onSaved: (value) {
              friendEmail = value ?? '';
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: ColorPalette.darkPink),
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
              foregroundColor: ColorPalette.darkTeal,
            ),
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/registration_input_validation.dart';

class FriendEmailInput extends StatelessWidget {
  final String? Function(String?)? validator;

  FriendEmailInput({this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: 'Friend Email',
        labelStyle:
            TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
        floatingLabelStyle:
            TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalette.darkCyan, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalette.darkTeal, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorPalette.darkPink, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: TextStyle(
          color: ColorPalette.darkPink,
          fontFamily: 'Poppins',
        ),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegistrationInputValidation.isEmailValid(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
      onSaved: (value) {
        final friendEmail = value ?? '';
      },
    );
  }
}

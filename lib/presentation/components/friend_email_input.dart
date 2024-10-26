import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/registration_input_validation.dart';

class FriendEmailInput extends StatelessWidget {
  final Function(String?)? onSaved;

  FriendEmailInput({this.onSaved});

  final List<String> suggestions = [
    'friend1@example.com',
    'friend2@example.com',
    'friend3@example.com',
  ];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return suggestions.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        controller.text = selection;
        if (onSaved != null) {
          onSaved!(selection);
        }
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: controller,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegistrationInputValidation.isEmailValid(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: onSaved,
        );
      },
    );
  }
}

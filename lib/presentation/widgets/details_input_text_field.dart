import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';

class DetailsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const DetailsTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    double textFieldFontSize = screenWidth * 0.045;
    double padding = screenWidth * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: ColorPalette.darkTeal,
          fontSize: textFieldFontSize,
        ),
        cursorColor: ColorPalette.darkTeal,
        decoration: InputDecoration(
          fillColor: ColorPalette.eggShell,
          filled: true,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: ColorPalette.darkTeal,
            fontSize: textFieldFontSize,
          ),
          floatingLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            color: ColorPalette.darkTeal,
            fontSize: textFieldFontSize,
          ),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkTeal, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkPink, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkCyan, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkTeal, width: 3),
          ),
        ),
        validator: validator ??
                (value) => value == null || value.isEmpty ? 'Enter $labelText' : null,
      ),
    );
  }
}


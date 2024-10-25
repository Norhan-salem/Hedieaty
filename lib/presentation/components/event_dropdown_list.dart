import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';

class EventDropdownButton extends StatelessWidget {
  final String? category;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const EventDropdownButton({
    Key? key,
    required this.category,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double dropdownFontSize = screenWidth * 0.045;
    double padding = screenWidth * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: DropdownButtonFormField<String>(
        value: category,
        decoration: InputDecoration(
          labelText: 'Category',
          filled: true,
          fillColor: ColorPalette.eggShell,
          labelStyle:
              TextStyle(fontFamily: 'Poppins', color: ColorPalette.darkTeal),
          floatingLabelStyle:
              TextStyle(fontFamily: 'Poppins', color: ColorPalette.darkTeal),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkCyan, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkPink, width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: ColorPalette.darkTeal, width: 3),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent, width: 3),
          ),
        ),
        items: items
            .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: ColorPalette.darkTeal,
                      fontSize: dropdownFontSize,
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        validator:
            validator ?? (value) => value == null ? 'Select a category' : null,
        dropdownColor: ColorPalette.eggShell,
      ),
    );
  }
}

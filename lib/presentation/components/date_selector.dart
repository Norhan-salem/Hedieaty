import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';

class DateSelector extends StatelessWidget {
  final ValueNotifier<DateTime?> selectedDateNotifier;

  const DateSelector({Key? key, required this.selectedDateNotifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    double verticalPadding = screenWidth * 0.02;
    double buttonFontSize = screenWidth * 0.04;
    double textFontSize = screenWidth * 0.04;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: 1)),
                firstDate: DateTime.now().add(Duration(days: 1)),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                selectedDateNotifier.value = pickedDate;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.darkCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: ColorPalette.darkTeal, width: 3),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: verticalPadding * 1.5),
            ),
            child: Text(
              'Select Date',
              style: TextStyle(
                color: ColorPalette.eggShell,
                fontFamily: 'Poppins',
                fontSize: buttonFontSize,
              ),
            ),
          ),
          ValueListenableBuilder<DateTime?>(
            valueListenable: selectedDateNotifier,
            builder: (context, selectedDate, child) {
              if (selectedDate != null) {
                return Padding(
                  padding: EdgeInsets.all(verticalPadding),
                  child: Text(
                    'Selected Date: ${selectedDate.toLocal().toIso8601String().split('T')[0]}',
                    style: TextStyle(
                      color: ColorPalette.darkCyan,
                      fontFamily: 'Poppins',
                      fontSize: textFontSize,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

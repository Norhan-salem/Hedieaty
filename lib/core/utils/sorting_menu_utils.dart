import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/constants/color_palette.dart';
import 'package:hedieaty_flutter_application/core/utils/sorting_utils.dart';

void showSortingMenu<T>(
    BuildContext context,
    ValueNotifier<List<T>> sortedItemsNotifier,
    ) {
  List<PopupMenuEntry<String>> sortMenuOptions = [
    PopupMenuItem<String>(
      value: 'Name',
      child: Text(
        'Sort by Name',
        style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
      ),
    ),
    PopupMenuItem<String>(
      value: 'Category',
      child: Text(
        'Sort by Category',
        style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
      ),
    ),
    PopupMenuItem<String>(
      value: 'Status',
      child: Text(
        'Sort by Status',
        style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
      ),
    ),
  ];

  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(100, 100, 0, 0),
    items: sortMenuOptions,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: ColorPalette.darkTeal, width: 1),
    ),
    color: ColorPalette.eggShell,
  ).then((value) {
    if (value != null) {
      sortItems(sortedItemsNotifier.value, value, sortedItemsNotifier);
    }
  });
}


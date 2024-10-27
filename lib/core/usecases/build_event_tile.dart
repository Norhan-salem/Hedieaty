import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../presentation/components/gift_details_tile.dart';
import '../constants/color_palette.dart';

Widget buildEventTile(BuildContext context, Event event) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        iconTheme: IconThemeData(
          size: 30,
          color: ColorPalette.darkTeal,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: ColorPalette.darkCyan,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ExpansionTile(
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: ColorPalette.darkTeal, width: 2),
          ),
          title: Text(
            event.name,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: ColorPalette.darkTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: event.gifts!
              .map((gift) => Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 4.0),
            child: GiftDetailsTile(
              text: gift.name,
            ),
          ))
              .toList(),
        ),
      ),
    ),
  );
}

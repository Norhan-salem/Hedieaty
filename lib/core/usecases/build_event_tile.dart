import 'package:flutter/material.dart';

import '../../data/models/event_model.dart';
import '../../presentation/components/gift_details_tile.dart';
import '../constants/color_palette.dart';
import '../../data/models/gift_model.dart';


class BuildEventTile extends StatelessWidget {
  final Event event;
  final List<Gift> gifts;

  const BuildEventTile({
    Key? key,
    required this.event,
    required this.gifts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            children: gifts
                .map((gift) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ),
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
}


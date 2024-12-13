import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/tile_decoration.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/gift_model.dart';
import '../../data/services/gift_service.dart';
import '../../domain/enums/GiftCategory.dart';
import '../../domain/enums/GiftStatus.dart';
import '../screens/gift_details_screen.dart';

class GiftTile extends StatelessWidget {
  final Gift gift;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const GiftTile({
    Key? key,
    required this.gift,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenHeight * 0.008,
        horizontal: screenWidth * 0.05,
      ),
      decoration: TileDecoration.tileBorder(),
      child: Card(
        margin: EdgeInsets.zero,
        color: gift.status == 1
            ? ColorPalette.yellowHighlight
            : ColorPalette.eggShell,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GiftDetailsScreen(gift: gift),
              ),
            );
          },
          child: ListTile(
            title: Text(
              gift.name,
              style: TextStyle(
                  color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
            ),
            subtitle: Text(
              '${mapGiftCategoryToString(GiftCategory.values[gift.category])} - ${mapGiftStatusToString(GiftStatus.values[gift.status])}',
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
            trailing: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: ColorPalette.eggShell,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: BorderSide(color: ColorPalette.darkTeal, width: 1),
                  ),
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> options = [];

                  if (gift.status!= 1) {
                    options.add(
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: ColorPalette.darkTeal,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    );
                  }

                  options.add(
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: ColorPalette.darkTeal,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );

                  return options;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

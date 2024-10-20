import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/tile_decoration.dart';
import '../../core/constants/color_palette.dart';
import 'gift_list.dart';

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
          vertical: screenHeight * 0.008, horizontal: screenWidth * 0.05),
      decoration: TileDecoration.tileBorder(),
      child: Card(
        margin: EdgeInsets.zero,
        color: gift.status == 'pledged'
            ? ColorPalette.lightYellow
            : ColorPalette.eggShell,
        child: ListTile(
          title: Text(gift.name,
              style: TextStyle(
                  color: ColorPalette.darkTeal, fontFamily: 'Poppins')),
          subtitle: Text('${gift.category} - ${gift.status}',
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          trailing: PopupMenuButton<String>(
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
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit',
                      style: TextStyle(
                          color: ColorPalette.darkTeal,
                          fontFamily: 'Poppins'))),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete',
                      style: TextStyle(
                          color: ColorPalette.darkTeal,
                          fontFamily: 'Poppins'))),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/core/utils/tile_decoration.dart';
import '../../core/constants/color_palette.dart';
import '../../data/models/gift_model.dart';
import '../../domain/managers/gift_pledge_manager.dart';

class FriendGiftTile extends StatelessWidget {
  final Gift gift;
  final GiftPledgeManager pledgeManager;

  const FriendGiftTile({
    Key? key,
    required this.gift,
    required this.pledgeManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => showPledgeDialog(context, gift, pledgeManager),
      child: Container(
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
          ),
        ),
      ),
    );
  }
}

//pledge gift t8yyr lonha le asfr wel status le pledged
void showPledgeDialog(
    BuildContext context, Gift gift, GiftPledgeManager pledgeManager) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Gift Options'),
        content: Text(
          pledgeManager.canPledgeGift(gift)
              ? 'Do you want to pledge this gift or view details?'
              : 'This gift has already been pledged. You can only view details.',
        ),
        actions: [
          if (pledgeManager.canPledgeGift(gift))
            TextButton(
              onPressed: () {
                pledgeManager.pledgeGift(gift);
                Navigator.pop(context);
              },
              child: Text('Pledge Gift'),
            ),
          TextButton(
            onPressed: () {
              // Add navigation to gift details screen
              Navigator.pop(context);
            },
            child: Text('View Details'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/services/gift_service.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/tile_decoration.dart';
import '../../data/models/gift_model.dart';
import '../../domain/enums/GiftCategory.dart';
import '../../domain/enums/GiftStatus.dart';
import '../../domain/managers/gift_pledge_manager.dart';
import '../screens/gift_details_screen.dart';
import '../widgets/custom_alert_dialog.dart';

class FriendGiftTile extends StatefulWidget {
  final Gift gift;
  final GiftPledgeManager pledgeManager;

  const FriendGiftTile({
    Key? key,
    required this.gift,
    required this.pledgeManager,
  }) : super(key: key);

  @override
  _FriendGiftTileState createState() => _FriendGiftTileState();
}

class _FriendGiftTileState extends State<FriendGiftTile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLandscape = screenWidth > screenHeight;

    return GestureDetector(
      onTap: () => showPledgeDialog(context),
      child: Center(
        child: Container(
          width: isLandscape ? screenWidth * 0.6 : double.infinity,
          margin: EdgeInsets.symmetric(
            vertical: isLandscape ? screenHeight * 0.02 : screenHeight * 0.008,
            horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.05,
          ),
          decoration: TileDecoration.tileBorder(),
          child: Card(
            margin: EdgeInsets.zero,
            color: widget.gift.status == GiftStatus.pledged.index
                ? ColorPalette.yellowHighlight
                : ColorPalette.eggShell,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: isLandscape ? screenWidth * 0.03 : screenWidth * 0.04,
                vertical: isLandscape ? screenHeight * 0.005 : screenHeight * 0.001,
              ),
              title: Text(
                widget.gift.name,
                style: TextStyle(
                  fontSize: isLandscape ? screenWidth * 0.025 : screenWidth * 0.04,
                  color: ColorPalette.darkTeal,
                  fontFamily: 'Poppins',
                ),
              ),
              subtitle: Text(
                '${mapGiftCategoryToString(GiftCategory.values[widget.gift.category])} - ${mapGiftStatusToString(GiftStatus.values[widget.gift.status])}',
                style: TextStyle(
                  fontSize: isLandscape ? screenWidth * 0.02 : screenWidth * 0.035,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showPledgeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: 'Gift Options',
          content: Text(
            widget.pledgeManager.canPledgeGift(widget.gift)
                ? 'Do you want to pledge this gift or view details?'
                : 'This gift has already been pledged. You can only view details.',
            style: TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
          ),
          actions: [
            if (widget.pledgeManager.canPledgeGift(widget.gift))
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorPalette.darkPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: ColorPalette.darkTeal, width: 3),
                ),
                onPressed: () async {
                  final success = await widget.pledgeManager.pledgeGift(widget.gift);

                  if (success) {
                    setState(() {
                      widget.gift.status = GiftStatus.pledged.index;
                    });
                  }

                  Navigator.pop(context);
                },
                child: Text(
                  'Pledge Gift',
                  style: TextStyle(
                    color: ColorPalette.eggShell,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.darkCyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: ColorPalette.darkTeal, width: 3),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiftDetailsScreen(gift: widget.gift),
                  ),
                );
              },
              child: Text(
                'View Details',
                style: TextStyle(
                  color: ColorPalette.eggShell,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: ColorPalette.darkPink,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

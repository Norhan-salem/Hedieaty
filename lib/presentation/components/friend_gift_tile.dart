import 'package:flutter/material.dart';

import '../../core/constants/color_palette.dart';
import '../../core/utils/tile_decoration.dart';
import '../../data/models/gift_model.dart';
import '../../domain/managers/gift_pledge_manager.dart';

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

    return GestureDetector(
      onTap: () => showPledgeDialog(context),
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenHeight * 0.008, horizontal: screenWidth * 0.05),
        decoration: TileDecoration.tileBorder(),
        child: Card(
          margin: EdgeInsets.zero,
          color: widget.gift.status == 'pledged'
              ? ColorPalette.lightYellow
              : ColorPalette.eggShell,
          child: ListTile(
            title: Text(widget.gift.name,
                style: TextStyle(
                    color: ColorPalette.darkTeal, fontFamily: 'Poppins')),
            subtitle: Text('${widget.gift.category} - ${widget.gift.status}',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
          ),
        ),
      ),
    );
  }

  void showPledgeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorPalette.eggShell,
          title: Text(
            'Gift Options',
            style:
                TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
          ),
          content: Text(
            widget.pledgeManager.canPledgeGift(widget.gift)
                ? 'Do you want to pledge this gift or view details?'
                : 'This gift has already been pledged. You can only view details.',
            style:
                TextStyle(color: ColorPalette.darkTeal, fontFamily: 'Poppins'),
          ),
          actions: [
            if (widget.pledgeManager.canPledgeGift(widget.gift))
              TextButton(
                onPressed: () {
                  print('Pledging gift: ${widget.gift.name}');
                  widget.pledgeManager.pledgeGift(widget.gift);
                  print('New status: ${widget.gift.status}');
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Text('Pledge Gift',
                    style: TextStyle(
                        color: ColorPalette.darkTeal, fontFamily: 'Poppins')),
              ),
            TextButton(
              onPressed: () {
                // Add navigation to gift details screen
                Navigator.pop(context);
              },
              child: Text('View Details',
                  style: TextStyle(
                      color: ColorPalette.darkTeal, fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',
                  style: TextStyle(
                      color: ColorPalette.darkPink, fontFamily: 'Poppins')),
            ),
          ],
        );
      },
    );
  }
}

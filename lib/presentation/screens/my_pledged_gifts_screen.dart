import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/presentation/components/gift_details_tile.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';

import '../../core/constants/color_palette.dart';
import '../widgets/custom_alert_dialog.dart';

// this will also be changed later :((((((((((
class PledgedGift {
  final String giftName;
  final String friendName;
  final DateTime dueDate;
  final bool isPending;

  PledgedGift({
    required this.giftName,
    required this.friendName,
    required this.dueDate,
    required this.isPending,
  });
}

class MyPledgedGiftsScreen extends StatelessWidget {
  final List<PledgedGift> pledgedGifts;

  MyPledgedGiftsScreen({Key? key, required this.pledgedGifts})
      : super(key: key);

  void _showUnpledgeDialog(BuildContext context, PledgedGift gift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Unpledge Gift',
          content:
              Text('Are you sure you want to unpledge "${gift.giftName}"?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
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
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.darkPink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: BorderSide(color: ColorPalette.darkTeal, width: 3),
              ),
              onPressed: () {
                // Add logic to unpledge the gift and delete it from list
                Navigator.pop(context);
              },
              child: Text(
                'Unpledge Gift',
                style: TextStyle(
                  color: ColorPalette.eggShell,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Pledged Gifts'),
      ),
      body: Stack(
        children: [
          BackgroundContainer(
            child: ListView.builder(
              itemCount: pledgedGifts.length,
              itemBuilder: (context, index) {
                PledgedGift gift = pledgedGifts[index];

                return GiftDetailsTile(
                  height: screenHeight * 0.12,
                  text: '${gift.giftName}\n'
                      'Pledged to: ${gift.friendName}\n'
                      'Due Date: ${gift.dueDate.toLocal().toIso8601String().split('T')[0]}',
                  trailing: gift.isPending
                      ? IconButton(
                          iconSize: screenWidth * 0.08,
                          icon: Icon(Icons.highlight_remove_outlined,
                              color: ColorPalette.darkPink),
                          onPressed: () {
                            if (gift.dueDate.isAfter(DateTime.now())) {
                              _showUnpledgeDialog(context, gift);
                            }
                          },
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/repositories/gift_repository.dart';
import 'package:hedieaty_flutter_application/presentation/components/gift_details_tile.dart';
import 'package:hedieaty_flutter_application/presentation/widgets/background_image_container.dart';

import '../../core/constants/color_palette.dart';
import '../../data/models/gift_model.dart';
import '../../data/repositories/event_repository.dart';
import '../widgets/custom_alert_dialog.dart';
import '../widgets/custom_app_bar.dart';

class MyPledgedGiftsScreen extends StatelessWidget {
  final Future<List<Gift>> pledgedGifts;

  MyPledgedGiftsScreen({Key? key, required this.pledgedGifts})
      : super(key: key);

  void _showUnpledgeDialog(BuildContext context, Gift gift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Unpledge Gift',
          content: Text('Are you sure you want to unpledge "${gift.name}"?'),
          actions: [
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
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.darkPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: ColorPalette.darkTeal, width: 3),
              ),
              onPressed: () {
                GiftRepository().unpledgeGift(gift.id, gift.eventId);
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
      appBar: CustomAppBar(
        title: 'My Pledged Gifts',
      ),
      body: FutureBuilder<List<Gift>>(
        future: pledgedGifts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No pledged gifts found.'));
          }

          final gifts = snapshot.data!;
          return BackgroundContainer(
            child: ListView.builder(
              itemCount: gifts.length,
              itemBuilder: (context, index) {
                final gift = gifts[index];
                return FutureBuilder<Map<String, dynamic>>(
                  future: _getGiftDetails(gift),
                  builder: (context, giftSnapshot) {
                    if (giftSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (giftSnapshot.hasError || !giftSnapshot.hasData) {
                      return Center(child: Text('Error loading gift details.'));
                    } else {
                      final eventOwner = giftSnapshot.data!['owner'] as String;
                      final eventDate = giftSnapshot.data!['date'] as DateTime?;
                      final isCloseToEvent =
                          giftSnapshot.data!['isCloseToEvent'] as bool;

                      return GiftDetailsTile(
                        height: screenHeight * 0.12,
                        text: '${gift.name}\n'
                            'Pledged to: $eventOwner\n'
                            'Event Date: ${eventDate?.toLocal().toIso8601String().split('T')[0] ?? 'Unknown'}',
                        trailing: isCloseToEvent
                            ? IconButton(
                                iconSize: screenWidth * 0.08,
                                icon: Icon(
                                  Icons.highlight_remove_outlined,
                                  color: ColorPalette.darkPink,
                                ),
                                onPressed: () {
                                  _showUnpledgeDialog(context, gift);
                                },
                              )
                            : null,
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getGiftDetails(Gift gift) async {
    final owner =
        await EventRepository().getEventOwner(gift.eventId) ?? 'Unknown';
    final dateString = await EventRepository().getEventDate(gift.eventId);
    DateTime? date;
    if (dateString != null) {
      date = DateTime.tryParse(dateString);
    }
    final isCloseToEvent =
        date != null && date.difference(DateTime.now()).inDays < 3;
    return {
      'owner': owner,
      'date': date,
      'isCloseToEvent': !isCloseToEvent,
    };
  }
}

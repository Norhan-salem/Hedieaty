import 'package:flutter/material.dart';
import '../../data/models/gift_model.dart';
import '../../domain/managers/gift_pledge_manager.dart';
import 'friend_gift_tile.dart';

class FriendGiftList extends StatelessWidget {
  final List<Gift> friendGifts;
  final GiftPledgeManager pledgeManager = GiftPledgeManager();

  FriendGiftList({required this.friendGifts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friendGifts.length,
      itemBuilder: (context, index) {
        final gift = friendGifts[index];
        return FriendGiftTile(
          gift: gift,
          pledgeManager: pledgeManager,
        );
      },
    );
  }
}

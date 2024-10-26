import 'package:flutter/material.dart';

import '../../data/models/gift_model.dart';
import '../screens/add_edit_gift_screen.dart';
import 'gift_tile.dart';

class GiftList extends StatefulWidget {
  final List<Gift> myGifts;
  final Function(Gift) onGiftAdded;

  GiftList({required this.myGifts, required this.onGiftAdded});

  @override
  _GiftListState createState() => _GiftListState();
}

class _GiftListState extends State<GiftList> {
  void _deleteGift(int index) {
    setState(() {
      widget.myGifts.removeAt(index);
    });
  }

  void _updateGift(int index, Gift updatedGift) {
    setState(() {
      widget.myGifts[index] = updatedGift;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.myGifts.length,
      itemBuilder: (context, index) {
        final gift = widget.myGifts[index];
        return GiftTile(
          gift: gift,
          onEdit: () {
            Navigator.push<Gift>(
              context,
              MaterialPageRoute(
                builder: (context) => AddGiftScreen(gift: gift),
              ),
            ).then((updatedGift) {
              if (updatedGift != null) {
                _updateGift(index, updatedGift);
              }
            });
          },
          onDelete: () {
            // Implement delete functionality
            _deleteGift(index);
          },
        );
      },
    );
  }
}

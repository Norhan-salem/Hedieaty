import 'package:flutter/material.dart';
import 'package:hedieaty_flutter_application/data/repositories/gift_repository.dart';

import '../../data/models/gift_model.dart';
import '../screens/add_edit_gift_screen.dart';
import 'gift_tile.dart';

class GiftList extends StatefulWidget {
  final int eventId;
  final List<Gift> myGifts;
  final Function(Gift) onGiftAdded;

  GiftList({required this.myGifts, required this.onGiftAdded, required this.eventId});

  @override
  _GiftListState createState() => _GiftListState();
}

class _GiftListState extends State<GiftList> {
  Future<void> _deleteGift(int index) async {
    try {
      final giftId = widget.myGifts[index].id;
      if (giftId != null) {
        await GiftRepository().deleteGift(giftId);
        setState(() {
          widget.myGifts.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gift deleted successfully!')),
        );
      } else {
        throw Exception('Invalid gift ID.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete gift: $e')),
      );
    }
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
                builder: (context) => AddGiftScreen(gift: gift, eventId: widget.eventId),
              ),
            ).then((updatedGift) {
              if (updatedGift != null) {
                _updateGift(index, updatedGift);
              }
            });
          },
          onDelete: () {
            _deleteGift(index);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'gift_tile.dart';

class Gift {
  final String name;
  final String category;
  final String status; // e.g., "available", "pledged"

  Gift({required this.name, required this.category, required this.status});
}

class GiftList extends StatelessWidget {
  final List<Gift> gifts = [
    Gift(name: 'Smartphone', category: 'Electronics', status: 'available'),
    Gift(name: 'Book', category: 'Education', status: 'pledged'),
    Gift(name: 'Headphones', category: 'Electronics', status: 'available'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gifts.length,
      itemBuilder: (context, index) {
        final gift = gifts[index];
        return GiftTile(
          gift: gift,
          onEdit: () {
            // Implement edit functionality here
          },
          onDelete: () {
            // Implement delete functionality here
          },
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hedieaty_flutter_application/domain/enums/GiftStatus.dart';

import '../../domain/enums/GiftCategory.dart';

class Gift {
  int id;
  String name;
  String giftImagePath;
  String description;
  int category;
  double price;
  int status;
  int eventId;
  String pledged_by_user_id;
  bool isDeleted;
  bool isPublished;

  Gift(
      {required this.id,
      required this.name,
      required this.giftImagePath,
      required this.description,
      required this.category,
      required this.price,
      required this.status,
      required this.eventId,
      required this.pledged_by_user_id,
      this.isDeleted = false,
      this.isPublished = false});

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      name: map['name'],
      giftImagePath: map['gift_image_path'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      status: map['status'],
      eventId: map['event_id'],
      pledged_by_user_id: map['pledged_by_user_id'],
      isDeleted: map['isDeleted'] == false,
      isPublished: map['isPublished'] == false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gift_image_path': giftImagePath,
      'description': description,
      'category': category,
      'price': price,
      'status': status,
      'event_id': eventId,
      'pledged_by_user_id': pledged_by_user_id,
      'isDeleted': isDeleted ? true : false,
      'isPublished': isPublished ? true : false
    };
  }

  factory Gift.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Gift(
      id: data['id'],
      name: data['name'] ?? '',
      status: data['status'] ?? '',
      pledged_by_user_id: data['pledged_by_user_id'] ?? '',
      giftImagePath: data['gift_image_path'],
      description: data['description'],
      category: data['category'],
      eventId: data['event_id'],
      isDeleted: data['isDeleted'],
      isPublished: data['isPublished'],
      price: data['price'],


    );
  }

  GiftCategory get giftCategory => GiftCategory.values[category];

  set giftCategory(GiftCategory category) {
    this.category = category.index;
  }

  GiftStatus get giftStatus => GiftStatus.values[status];

  set giftStatus(GiftStatus status) {
    this.status = status.index;
  }
}

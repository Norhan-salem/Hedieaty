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
      isDeleted: map['isDeleted'] == 0,
      isPublished: map['isPublished'] == 0,
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
      'isDeleted': isDeleted ? 1 : 0,
      'isPublished': isPublished ? 1 : 0
    };
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

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
  bool isDeleted;

  Gift({
    required this.id,
    required this.name,
    required this.giftImagePath,
    required this.description,
    required this.category,
    required this.price,
    required this.status,
    required this.eventId,
    this.isDeleted = false,
  });

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
      isDeleted: map['isDeleted'] == 1,
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
      'isDeleted': isDeleted ? 1 : 0,
    };
  }

  GiftCategory get giftCategory => GiftCategory.values[category];

  set giftCategory(GiftCategory category) {
    this.category = category.index;
  }
}

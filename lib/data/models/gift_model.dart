class Gift {
  String? imageURL = 'assets/images/gift_default_img.png';
  final String name;
  final String category;
  String status; // e.g., "available", "pledged"
  final double price;
  final String description;

  Gift({
    this.imageURL,
    required this.name,
    required this.category,
    required this.status,
    required this.price,
    required this.description,
  });
}


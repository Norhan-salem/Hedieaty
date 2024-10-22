class Gift {
  final String name;
  final String category;
  late final String status; // e.g., "available", "pledged"

  Gift({required this.name, required this.category, required this.status});
}

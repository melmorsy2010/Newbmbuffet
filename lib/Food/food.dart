class Food {
  final String name;
  final String imageUrl;

  Food({
    required this.name,
    required this.imageUrl,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

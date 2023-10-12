class juice66 {
  final String name;
  final String imageUrl;
  bool isFavorite;

  juice66({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,

  });

  factory juice66.fromJson(Map<String, dynamic> json) {
    return juice66(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

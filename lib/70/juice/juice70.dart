class juice70 {
  final String name;
  final String imageUrl;
  bool isFavorite;

  juice70({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,

  });

  factory juice70.fromJson(Map<String, dynamic> json) {
    return juice70(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

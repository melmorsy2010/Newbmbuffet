class juice {
  final String name;
  final String imageUrl;
  bool isFavorite;

  juice({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,

  });

  factory juice.fromJson(Map<String, dynamic> json) {
    return juice(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

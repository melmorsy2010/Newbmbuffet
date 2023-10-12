class Food66 {
  final String name;
  final String imageUrl;

  Food66({
    required this.name,
    required this.imageUrl,
  });

  factory Food66.fromJson(Map<String, dynamic> json) {
    return Food66(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

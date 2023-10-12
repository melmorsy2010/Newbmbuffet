class Food70 {
  final String name;
  final String imageUrl;

  Food70({
    required this.name,
    required this.imageUrl,
  });

  factory Food70.fromJson(Map<String, dynamic> json) {
    return Food70(
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

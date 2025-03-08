class ProductModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final double rating;
  final String category;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'price': price,
      'rating': rating,
      'category': category,
    };
  }

  @override
  List<Object?> get props =>
      [id, title, description, imageUrl, price, rating, category];
}

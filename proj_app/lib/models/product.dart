class Product {
  String name = '';
  double price = 0.0;
  String originCountry = '';
  int score = 0;
  String stores = '';
  String? image = '';
  String? imageScore;
  String note; // Add a field for the note

  Product({
    required this.name,
    required this.price,
    required this.originCountry,
    required this.score,
    required this.stores,
    this.image,
    this.imageScore,
    this.note = '', // Set default value for the note
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0) as double,
      originCountry: json['originCountry'] ?? '',
      score: json['score'] ?? 0,
      stores: json['stores'] ?? '',
      image: json['image'] ?? '',
      imageScore: json['imageScore'] ?? '',
    );
  }

  Product copyWith({
    String? name,
    double? price,
    String? originCountry,
    int? score,
    String? stores,
    String? image,
    String? imageScore,
  }) {
    return Product(
      name: name ?? this.name,
      price: price ?? this.price,
      originCountry: originCountry ?? this.originCountry,
      score: score ?? this.score,
      stores: stores ?? this.stores,
      image: image ?? this.image,
      imageScore: imageScore ?? this.imageScore,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'originCountry': originCountry,
      'score': score,
      'stores': stores,
      'image': image,
      'imageScore': imageScore,
    };
  }

}

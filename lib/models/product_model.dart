class Product {
  String name;
  String type;
  String cost;
  String image;
  String category;
  bool _isLike = false;

  Product({
    required this.name,
    required this.cost,
    required this.type,
    required this.image,
    required this.category,
  });

  bool get isLike => _isLike;
  set isLike(bool value) => _isLike = value;
}

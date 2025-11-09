class ProductModel {
  int? id;
  String? name;
  double? price;
  String? imageFullUrl;
  double? rating;
  String? restaurantName;
  double? discount;
  String? discountType;
  int? minDeliveryTime;
  int? maxDeliveryTime;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.imageFullUrl,
    this.rating,
    this.restaurantName,
    this.discount,
    this.discountType,
    this.minDeliveryTime,
    this.maxDeliveryTime,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price']?.toDouble(),
      imageFullUrl: json['image_full_url'] ?? json['image'],
      rating: json['avg_rating']?.toDouble(),
      restaurantName: json['restaurant_name'],
      discount: json['discount']?.toDouble(),
      discountType: json['discount_type'],
      minDeliveryTime: json['min_delivery_time'],
      maxDeliveryTime: json['max_delivery_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_full_url': imageFullUrl,
      'avg_rating': rating,
      'restaurant_name': restaurantName,
      'discount': discount,
      'discount_type': discountType,
      'min_delivery_time': minDeliveryTime,
      'max_delivery_time': maxDeliveryTime,
    };
  }
}

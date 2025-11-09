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

  // ========== Safe Getters with Null Handling ==========
  //
  // These getters provide null-safe access to model properties with sensible defaults.
  // Use these instead of directly accessing nullable fields to avoid null pointer exceptions.
  //
  // Example:
  //   Text(product.safeName)  // Safe - returns empty string if null
  //   Text(product.name!)     // Unsafe - throws if null
  //

  /// Returns the product name, or empty string if null.
  String get safeName => name ?? '';

  /// Returns the restaurant name, or empty string if null.
  String get safeRestaurantName => restaurantName ?? '';

  /// Returns the full image URL, or empty string if null.
  String get safeImageUrl => imageFullUrl ?? '';

  /// Returns the product price, or 0.0 if null.
  double get safePrice => price ?? 0.0;

  /// Returns the product rating (0-5), or 0.0 if null.
  double get safeRating => rating ?? 0.0;

  /// Returns the discount amount, or 0.0 if null.
  double get safeDiscount => discount ?? 0.0;

  /// Returns the discount type ('percent' or 'amount'), defaults to 'percent'.
  String get safeDiscountType => discountType ?? 'percent';

  /// Returns the minimum delivery time in minutes, or 0 if null.
  int get safeMinDeliveryTime => minDeliveryTime ?? 0;

  /// Returns the maximum delivery time in minutes, or 0 if null.
  int get safeMaxDeliveryTime => maxDeliveryTime ?? 0;
}

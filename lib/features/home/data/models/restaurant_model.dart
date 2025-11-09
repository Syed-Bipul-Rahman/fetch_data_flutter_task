class RestaurantModel {
  int? id;
  String? name;
  String? logoFullUrl;
  double? rating;

  RestaurantModel({this.id, this.name, this.logoFullUrl, this.rating});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'],
      name: json['name'],
      logoFullUrl: json['logo_full_url'],
      rating: json['avg_rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_full_url': logoFullUrl,
      'avg_rating': rating,
    };
  }

  // ========== Safe Getters with Null Handling ==========

  /// Returns the restaurant name, or empty string if null.
  String get safeName => name ?? '';

  /// Returns the full logo URL, or empty string if null.
  String get safeLogoUrl => logoFullUrl ?? '';

  /// Returns the restaurant rating (0-5), or 0.0 if null.
  double get safeRating => rating ?? 0.0;
}

class RestaurantsResponse {
  int? totalSize;
  List<RestaurantModel>? data;

  RestaurantsResponse({this.totalSize, this.data});

  factory RestaurantsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantsResponse(
      totalSize: json['total_size'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((i) => RestaurantModel.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_size': totalSize,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class BannerModel {
  int? id;
  String? image;
  String? imageFullUrl;
  String? title;

  BannerModel({this.id, this.image, this.imageFullUrl, this.title});

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
      imageFullUrl: json['image_full_url'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'image_full_url': imageFullUrl,
      'title': title,
    };
  }

  // ========== Safe Getters with Null Handling ==========

  /// Returns the full image URL, falling back to image path, or empty string if both are null.
  String get safeImageUrl => imageFullUrl ?? image ?? '';

  /// Returns the banner title, or empty string if null.
  String get safeTitle => title ?? '';
}

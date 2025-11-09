class CategoryModel {
  int? id;
  String? name;
  String? imageFullUrl;
  List<CategoryModel>? childes;

  CategoryModel({this.id, this.name, this.imageFullUrl, this.childes});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      imageFullUrl: json['image_full_url'],
      childes: json['childes'] != null
          ? (json['childes'] as List)
                .map((i) => CategoryModel.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_full_url': imageFullUrl,
      'childes': childes?.map((e) => e.toJson()).toList(),
    };
  }

  // ========== Safe Getters with Null Handling ==========

  /// Returns the category name, or empty string if null.
  String get safeName => name ?? '';

  /// Returns the full image URL, or empty string if null.
  String get safeImageUrl => imageFullUrl ?? '';

  /// Returns the list of sub-categories, or empty list if null.
  List<CategoryModel> get safeChildes => childes ?? [];
}

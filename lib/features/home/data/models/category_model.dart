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
}

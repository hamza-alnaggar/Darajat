// features/categories/data/models/category_response_model.dart
class CategoryResponseModel {
  final List<CategoryModel> data;

  CategoryResponseModel({
    required this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      data: (json['data'] as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList(),
    );
  }
}

class CategoryModel {
  final int id;
  final String title;
  final String imageUrl;

  CategoryModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['name'],
      imageUrl: json['image_url'],
    );
  }
}
// features/categories/data/datasources/category_remote_data_source.dart
import 'package:learning_management_system/core/databases/api/api_consumer.dart';
import 'package:learning_management_system/core/databases/api/end_points.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';

class CategoryRemoteDataSource {
  final ApiConsumer api;

  CategoryRemoteDataSource({required this.api});

  Future<CategoryResponseModel> getAllCategories() async {
    final response = await api.get(EndPoints.categories);
    return CategoryResponseModel.fromJson(response);
  }
}
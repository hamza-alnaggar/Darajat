// features/categories/presentation/cubit/category_state.dart

import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;

  CategorySuccess({required this.categories});
}

class CategoryEmpty extends CategoryState {}

class CategoryFailure extends CategoryState {
  final String errMessage;

  CategoryFailure({required this.errMessage});
}

class ChangeData extends CategoryState{}
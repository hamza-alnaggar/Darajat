// features/categories/presentation/cubit/category_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_management_system/features/courses/data/models/category_response_model.dart';
import 'package:learning_management_system/features/courses/data/repositories/category_repository.dart';
import 'package:learning_management_system/features/courses/presentation/cubit/category_state.dart';


class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository repository;

  CategoryCubit({required this.repository}) : super(CategoryInitial());

  List<CategoryModel> categoryList = [];

  CategoryModel ?selectedCategory ; 




  Future<void> getAllCategories() async {
    emit(CategoryLoading());
    final response = await repository.getAllCategories();
    response.fold(
      (failure) => emit(CategoryFailure(errMessage: failure.errMessage)),
      (categoriesResponse) {
        if (categoriesResponse.data.isEmpty) {
          emit(CategoryEmpty());
        } else {
          categoryList = categoriesResponse.data;
          emit(CategorySuccess(categories: categoriesResponse.data));
        }
      },
    );
  }
  
  void selectCategory(CategoryModel category) {
    selectedCategory = category;
    emit(ChangeData());  
  }
}
part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<String> categories;
  final List<CategoryModel> categoryModels;

  CategoryLoaded({
    required this.categories,
    required this.categoryModels,
  });
}

class CategoryError extends CategoryState {
  final String message;
  final List<String> fallbackCategories;

  CategoryError(this.message, {required this.fallbackCategories});
}

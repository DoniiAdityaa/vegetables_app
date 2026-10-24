import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegetables_app/config/constant.dart';
import 'package:vegetables_app/model/vegetable_model/category_model.dart';
import 'package:vegetables_app/repository/vegetable_repository.dart';
import 'package:vegetables_app/utility/resource/data_state.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final VegetableRepository _vegetableRepository;

  CategoryCubit(this._vegetableRepository) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());

    final result = await _vegetableRepository.getCategories();

    if (result is DataStateSuccess) {
      final list = result.data?.data ?? [];
      final categoryNames = ['Semua', ...list.map((c) => c.nama)];
      emit(CategoryLoaded(
        categories: categoryNames,
        categoryModels: list,
      ));
    } else if (result is DataStateError) {
      emit(CategoryError(
        result.exception?.message ?? 'Gagal memuat kategori dari server.',
        fallbackCategories: vegetableCategories,
      ));
    }
  }
}

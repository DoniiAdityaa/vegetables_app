import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_detail_model.dart';
import 'package:vegetables_app/repository/vegetable_repository.dart';
import 'package:vegetables_app/utility/resource/data_state.dart';

part 'vegetable_detail_state.dart';

class VegetableDetailCubit extends Cubit<VegetableDetailState> {
  final VegetableRepository _vegetableRepository;

  VegetableDetailCubit(this._vegetableRepository)
      : super(VegetableDetailInitial());

  Future<void> getDetail(int id) async {
    emit(VegetableDetailLoading());
    final result = await _vegetableRepository.getVegetableDetail(id: id);

    if (result is DataStateSuccess && result.data?.data != null) {
      emit(VegetableDetailLoaded(result.data!.data!));
    } else if (result is DataStateError) {
      final errorMessage =
          result.exception?.message ?? 'Gagal memuat detail sayuran.';
      emit(VegetableDetailError(errorMessage));
    }
  }
}

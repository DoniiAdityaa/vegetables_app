import 'package:vegetables_app/data/api/api_service.dart';
import 'package:vegetables_app/model/response/api_response.dart';
import 'package:vegetables_app/model/vegetable_model/category_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_detail_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';
import 'package:vegetables_app/repository/base/base_repository.dart';
import 'package:vegetables_app/utility/resource/data_state.dart';

class VegetableRepository extends BaseRepository {
  final ApiService _apiService;

  VegetableRepository(this._apiService);

  /// Mengambil daftar semua sayuran (mendukung filter kategori & pencarian)
  Future<DataState<ApiResponse<List<VegetableModel>>>> getVegetables({
    String? kategori,
    String? cari,
  }) {
    return getStateOf<ApiResponse<List<VegetableModel>>>(
      request: () => _apiService.getVegetables(
        kategori: kategori,
        cari: cari,
      ),
    );
  }

  /// Mengambil detail sayuran berdasarkan ID
  Future<DataState<ApiResponse<VegetableDetailModel>>> getVegetableDetail({
    required int id,
  }) {
    return getStateOf<ApiResponse<VegetableDetailModel>>(
      request: () => _apiService.getVegetableDetail(id: id),
    );
  }

  /// Mengambil daftar kategori sayuran dari API
  Future<DataState<ApiResponse<List<CategoryModel>>>> getCategories() {
    return getStateOf<ApiResponse<List<CategoryModel>>>(
      request: () => _apiService.getCategories(),
    );
  }
}
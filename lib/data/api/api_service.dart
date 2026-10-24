import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vegetables_app/config/constant.dart';
import 'package:vegetables_app/model/response/api_response.dart';
import 'package:vegetables_app/model/vegetable_model/category_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_detail_model.dart';
import 'package:vegetables_app/model/vegetable_model/vegetable_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: baseApi, parser: Parser.JsonSerializable)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('/vegetables')
  Future<HttpResponse<ApiResponse<List<VegetableModel>>>> getVegetables({
    @Query('kategori') String? kategori,
    @Query('cari') String? cari,
  });

  @GET('/vegetables/{id}')
  Future<HttpResponse<ApiResponse<VegetableDetailModel>>> getVegetableDetail({
    @Path('id') required int id,
  });

  @GET('/vegetables/categories')
  Future<HttpResponse<ApiResponse<List<CategoryModel>>>> getCategories();
}

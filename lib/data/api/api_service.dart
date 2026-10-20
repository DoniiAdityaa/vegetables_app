import 'package:dio/dio.dart';

import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';
import 'package:vegetables_app/config/constant.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: baseApi, parser: Parser.JsonSerializable)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // @GET('/vegetables')
  // Future<HttpResponse<ApiResponse<List>>>
}

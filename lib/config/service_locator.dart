import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetables_app/config/user_preference.dart';
import 'package:vegetables_app/feature/cart/cubit/cart_cubit.dart';
import 'package:vegetables_app/feature/detail/cubit/vegetable_detail_cubit.dart';
import 'package:vegetables_app/feature/favorite/cubit/favorite_cubit.dart';
import 'package:vegetables_app/feature/home/cubit/category_cubit.dart';
import 'package:vegetables_app/feature/home/cubit/vegetable_cubit.dart';

import '../data/api/api_service.dart';
import '../firebase/firebase_analytics_helper.dart';
import '../firebase/firebase_email_auth.dart';
import '../firebase/firebase_google.auth.dart';
import '../repository/vegetable_repository.dart';
import 'constant.dart';

/// Global [GetIt.instance].
final GetIt serviceLocator = GetIt.instance;

/// Set up [GetIt] locator.
Future<void> setUpLocator() async {
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(prefs);
  serviceLocator.registerSingleton<UserPreference>(UserPreference(prefs));

  serviceLocator.registerFactory<Dio>(() {
    final dio = Dio();
    kDebugMode ? dio.interceptors.add(AwesomeDioInterceptor()) : null;
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: timeOutDuration),
      receiveTimeout: const Duration(seconds: timeOutDuration),
      persistentConnection: false,
      headers: {
        'Content-Type': 'application/json',
        // 'Accept': 'application/json',
        // "x-api-key": Env.apiKey,
        // 'Authorization':
        //     'Bearer ${serviceLocator.get<UserPreference>().getToken()}',
      },
    );

    return dio;
  });

  serviceLocator.registerFactory<ApiService>(
    () => ApiService(serviceLocator.get<Dio>(), baseUrl: baseApi),
  );

  serviceLocator.registerFactory<VegetableRepository>(
    () => VegetableRepository(serviceLocator.get<ApiService>()),
  );

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  serviceLocator.registerSingleton<PackageInfo>(packageInfo);

  // Firebase Services
  serviceLocator.registerLazySingleton<FirebaseAnalyticsHelper>(
    () => FirebaseAnalyticsHelper(),
  );
  serviceLocator.registerLazySingleton<FirebaseEmailAuth>(
    () => FirebaseEmailAuth(),
  );
  serviceLocator.registerLazySingleton<FirebaseGoogleAuth>(
    () => FirebaseGoogleAuth(),
  );
  serviceLocator.registerFactory<VegetableCubit>(
    () => VegetableCubit(serviceLocator.get<VegetableRepository>()),
  );
  serviceLocator.registerFactory<CategoryCubit>(
    () => CategoryCubit(serviceLocator.get<VegetableRepository>()),
  );
  serviceLocator.registerFactory<VegetableDetailCubit>(
    () => VegetableDetailCubit(serviceLocator.get<VegetableRepository>()),
  );
  serviceLocator.registerLazySingleton<CartCubit>(
    () => CartCubit(serviceLocator.get<SharedPreferences>()),
  );
  serviceLocator.registerLazySingleton<FavoriteCubit>(
    () => FavoriteCubit(serviceLocator.get<SharedPreferences>()),
  );
}

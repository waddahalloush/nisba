import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Injects auth / locale / country headers and redirects to login on 401.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final storage = Get.find<GetStorageHelper>();

    final token = storage.authToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = storage.languageCode;

    final countryId = storage.countryId;
    if (countryId.isNotEmpty) {
      options.headers['X-Country-Id'] = countryId;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final storage = Get.find<GetStorageHelper>();
      await storage.clearStorage();
      Get.offNamedUntil(AppRoutesNames.login, (route) => true);
    }
    handler.next(err);
  }
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Response: ${response.data}');
    super.onResponse(response, handler);
  }
}

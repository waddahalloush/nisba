import 'package:dio/dio.dart';
import 'package:get/get.dart';

class DioErrorUtil {
  static String handleError(DioException error) {
    String errorDescription = "";
    switch (error.type) {
      case DioExceptionType.cancel:
        errorDescription = 'error_cancelled'.tr;
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = 'error_connection_timeout'.tr;
        break;
      case DioExceptionType.unknown:
        errorDescription = 'error_no_internet'.tr;
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = 'error_receive_timeout'.tr;
        break;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        if (statusCode == 500 ||
            statusCode == 400 ||
            statusCode == 401 ||
            statusCode == 404 ||
            statusCode == 403 ||
            statusCode == 423) {
          errorDescription =
              data?['message'] ??
              'error_server'.trParams({'statusCode': '$statusCode'});
        } else if (statusCode == 422) {
          errorDescription = data?['data']?[0] ?? 'error_validation'.tr;
        }

        break;
      case DioExceptionType.sendTimeout:
        errorDescription = 'error_send_timeout'.tr;
        break;
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        errorDescription = 'error_connection'.tr;
    }
    return errorDescription;
  }
}

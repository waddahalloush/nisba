import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/remote/constants/endpoints.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Interceptor that injects the auth token on every request and transparently
/// handles 401 errors by refreshing the token. If the refresh also fails, the
/// user is silently logged out and redirected to the login screen.
class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;
  final List<_QueuedRequest> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = Get.find<GetStorageHelper>().authToken;
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(dynamic response, ResponseInterceptorHandler handler) {
    // Keep the existing response logging behaviour
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only intercept 401 Unauthorized
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Prevent infinite retry loops — if this request was already retried once,
    // force logout instead of trying again.
    if (err.requestOptions.extra['_authRetry'] == true) {
      await _forceLogout();
      return handler.next(err);
    }

    // The refresh endpoint itself returned 401 — refresh token is expired.
    if (err.requestOptions.path.contains(EndPoints.refreshAccessToken)) {
      await _forceLogout();
      return handler.next(err);
    }

    // If a refresh is already in progress, queue this request so it can be
    // retried once the new token is available.
    if (_isRefreshing) {
      _pendingRequests.add(_QueuedRequest(err.requestOptions, handler));
      return;
    }

    _isRefreshing = true;

    try {
      // Use a bare Dio instance (no interceptors) for the refresh call to
      // avoid infinite recursion.
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: EndPoints.baseUrl,
          connectTimeout: EndPoints.connectionTimeout,
          receiveTimeout: EndPoints.receiveTimeout,
        ),
      );

      final storage = Get.find<GetStorageHelper>();
      final refreshToken = storage.refreshToken;

      final response = await refreshDio.post(
        EndPoints.refreshAccessToken,
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['data']['accessToken'] as String;
      final newRefreshToken = response.data['data']['refreshToken'] as String;

      storage.saveAuthToken(newAccessToken);
      storage.saveRefreshToken(newRefreshToken);

      _isRefreshing = false;

      // Retry the original failed request with the fresh token.
      await _retryRequest(err, handler, newAccessToken);

      // Retry all requests that were queued during the refresh.
      for (final pending in _pendingRequests) {
        _retryPendingRequest(pending, newAccessToken);
      }
      _pendingRequests.clear();
    } catch (_) {
      _isRefreshing = false;

      // Reject all queued requests — they can't succeed without a valid token.
      for (final pending in _pendingRequests) {
        pending.handler.next(err);
      }
      _pendingRequests.clear();

      await _forceLogout();
      handler.next(err);
    }
  }

  Future<void> _retryRequest(
    DioException err,
    ErrorInterceptorHandler handler,
    String newToken,
  ) async {
    final opts = err.requestOptions;
    opts.headers['Authorization'] = 'Bearer $newToken';
    opts.extra['_authRetry'] = true;

    try {
      final dio = Get.find<Dio>();
      final retryResponse = await dio.fetch(opts);
      handler.resolve(retryResponse);
    } catch (retryErr) {
      handler.next(retryErr as DioException);
    }
  }

  void _retryPendingRequest(_QueuedRequest pending, String newToken) {
    pending.options.headers['Authorization'] = 'Bearer $newToken';
    pending.options.extra['_authRetry'] = true;

    final dio = Get.find<Dio>();
    dio
        .fetch(pending.options)
        .then(
          (res) => pending.handler.resolve(res),
          onError: (e) => pending.handler.reject(e as DioException),
        );
  }

  Future<void> _forceLogout() async {
    final storage = Get.find<GetStorageHelper>();
    await storage.clearStorage();
    Get.offAllNamed(AppRoutesNames.login);
  }
}

class _QueuedRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  _QueuedRequest(this.options, this.handler);
}

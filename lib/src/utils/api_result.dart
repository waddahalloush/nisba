/// Helper for Laravel API envelope: `{ status, message, data }`.
class ApiResult {
  /// Treats both `status: "success"` and `status: true` as success.
  static bool isSuccess(dynamic res) {
    if (res is! Map) return false;
    final status = res['status'];
    if (status == true) return true;
    return status?.toString() == 'success';
  }

  static String message(dynamic res) =>
      (res is Map ? res['message'] : null)?.toString() ?? '';

  static dynamic data(dynamic res) => res is Map ? res['data'] : null;

  /// Returns [data] when status is success/true, otherwise throws [ApiException].
  static dynamic ensureSuccess(dynamic res) {
    if (isSuccess(res)) return data(res);
    throw ApiException(message(res).isNotEmpty ? message(res) : 'Request failed');
  }

  /// Alias of [ensureSuccess].
  static dynamic unwrap(dynamic res) => ensureSuccess(res);

  /// Returns message when failed, otherwise null.
  static String? failureMessage(dynamic res) =>
      isSuccess(res) ? null : (message(res).isNotEmpty ? message(res) : 'Request failed');
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../configs/api_response.dart';
import '../../../data/models/Home/notification_model.dart';
import '../../../data/repository.dart' show Repository;
import '../../../utils/api_result.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/dio_error_util.dart';
import '../../../utils/pagination_controller.dart';

class NotificationnController extends GetxController {
  final selectedTab = 0.obs; // 0 = today, 1 = all
  final selectedFilter = ''.obs; // '' = all

  final filters = <String>['الطلبات', 'التوصيل', 'العروض', 'الحساب'];

  // ── Date format used by the API: "26 05 26 02:02 pm" ──
  static final _apiDateFormat = DateFormat('yy MM dd hh:mm a', 'en');

  /// Parses the API's custom date string into a [DateTime], or returns null.
  static DateTime? tryParseApiDate(String raw) {
    try {
      return _apiDateFormat.parse(raw);
    } catch (_) {
      return null;
    }
  }

  // ── Dependencies ──
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  // ── Pagination ──
  late final pagination = PaginationController<NotificationItem>(
    perPage: 10,
    fetcher: (page, {query}) async {
      final res = await repository.getNotifications(page: page);
      return PaginatedResult(
        data: res.data.notifications,
        total: res.data.pagination.total,
        page: res.data.pagination.currentPage,
        perPage: res.data.pagination.perPage,
      );
    },
  );

  // ── Screen-level status (for initial load / full-page error) ──
  final Rx<Status> pageStatus = Status.init.obs;
  final RxString errorMessage = ''.obs;

  // ── Computed: filtered + reactive list ──
  List<NotificationItem> get filteredNotifications {
    var list = pagination.items.toList();

    // Type filter
    if (selectedFilter.value.isNotEmpty) {
      list = list
          .where(
            (n) =>
                n.notificationType.desc == selectedFilter.value ||
                n.notificationType.value == selectedFilter.value,
          )
          .toList();
    }

    // Today filter
    if (selectedTab.value == 0) {
      final today = DateTime.now();
      list = list.where((n) {
        final dt = tryParseApiDate(n.createdAt);
        if (dt == null) return false;
        return dt.year == today.year &&
            dt.month == today.month &&
            dt.day == today.day;
      }).toList();
    }

    return list;
  }

  // ── Tab / filter handlers ──
  void selectTab(int index) {
    selectedTab.value = index;
    pagination.items.refresh();
  }

  void toggleFilter(String filter) {
    selectedFilter.value = selectedFilter.value == filter ? '' : filter;
    pagination.items.refresh();
  }

  // ── Lifecycle ──
  @override
  void onInit() {
    super.onInit();
    loadInitialNotifications();
  }

  @override
  void onClose() {
    pagination.dispose();
    super.onClose();
  }

  // ── API ──
  Future<void> loadInitialNotifications() async {
    pageStatus.value = Status.loading;
    if (await connectionChecker.hasConnection) {
      try {
        await pagination.loadInitial();
        pageStatus.value = Status.completed;
      } on DioException catch (error) {
        log(error.response!.data['message'].toString());
        pageStatus.value = Status.error;
        errorMessage.value = DioErrorUtil.handleError(error);
        AppSnackbar.showError(message: errorMessage.value);
      }
    } else {
      pageStatus.value = Status.error;
      errorMessage.value = 'check_connection'.tr;
      AppSnackbar.showError(message: 'check_connection'.tr);
    }
  }

  Future<void> refreshNotifications() => pagination.refresh();

  /// Deletes a single notification, removing it locally right away.
  Future<void> deleteOneNotification(int id) async {
    try {
      final res = await repository.deleteOneNotification(id: id);
      ApiResult.ensureSuccess(res);
      pagination.items.removeWhere((n) => n.id == id);
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم حذف الإشعار',
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      AppSnackbar.showError(message: 'تعذر حذف الإشعار');
    }
  }

  /// Deletes all notifications and clears the local list.
  Future<void> deleteAllNotifications() async {
    try {
      final res = await repository.deleteAllNotifications();
      ApiResult.ensureSuccess(res);
      pagination.items.clear();
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم حذف جميع الإشعارات',
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      AppSnackbar.showError(message: 'تعذر حذف الإشعارات');
    }
  }
}

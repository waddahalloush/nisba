import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import '../../../configs/api_response.dart';
import '../../../data/repository.dart';
import '../../../utils/api_result.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/dio_error_util.dart';
import '../../../utils/pagination_controller.dart';

class InboxItem {
  final int id;
  final String title;
  final String message;
  final String? image;
  final String? file;
  final String createdAt;
  final bool isRead;

  const InboxItem({
    required this.id,
    required this.title,
    required this.message,
    this.image,
    this.file,
    required this.createdAt,
    required this.isRead,
  });

  factory InboxItem.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final readRaw = map['is_read'];
    final isRead = readRaw == true ||
        readRaw == 1 ||
        readRaw?.toString() == '1' ||
        readRaw?.toString().toLowerCase() == 'true';
    return InboxItem(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      title: map['title']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      image: map['image']?.toString(),
      file: map['file']?.toString(),
      createdAt: map['created_at']?.toString() ?? '',
      isRead: isRead,
    );
  }
}

class InboxController extends GetxController {
  static final _apiDateFormat = DateFormat('yy MM dd hh:mm a', 'en');
  static final _apiDateFormatAlt = DateFormat('yy m d h:s a', 'en');

  static DateTime? tryParseApiDate(String raw) {
    try {
      return _apiDateFormat.parse(raw);
    } catch (_) {
      try {
        return _apiDateFormatAlt.parse(raw);
      } catch (_) {
        return null;
      }
    }
  }

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  late final pagination = PaginationController<InboxItem>(
    perPage: 10,
    fetcher: (page, {query}) async {
      final res = await repository.getInboxes(page: page);
      final data = ApiResult.ensureSuccess(res);
      final map = data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
      final list = map['inboxes'] as List? ?? [];
      final paginationMap = map['pagination'] is Map
          ? Map<String, dynamic>.from(map['pagination'] as Map)
          : <String, dynamic>{};
      return PaginatedResult(
        data: list.whereType<Map>().map(InboxItem.fromApiMap).toList(),
        total: int.tryParse(paginationMap['total']?.toString() ?? '') ?? list.length,
        page: int.tryParse(paginationMap['current_page']?.toString() ?? '') ?? page,
        perPage: int.tryParse(paginationMap['per_page']?.toString() ?? '') ?? 10,
      );
    },
  );

  final Rx<Status> pageStatus = Status.init.obs;
  final RxString errorMessage = ''.obs;

  List<InboxItem> get inboxes => pagination.items.toList();

  @override
  void onInit() {
    super.onInit();
    loadInitialInboxes();
  }

  @override
  void onClose() {
    pagination.dispose();
    super.onClose();
  }

  Future<void> loadInitialInboxes() async {
    pageStatus.value = Status.loading;
    if (await connectionChecker.hasConnection) {
      try {
        await pagination.loadInitial();
        pageStatus.value = Status.completed;
      } on ApiException catch (e) {
        pageStatus.value = Status.error;
        errorMessage.value = e.message;
        AppSnackbar.showError(message: e.message);
      } on DioException catch (error) {
        log(error.toString());
        pageStatus.value = Status.error;
        errorMessage.value = DioErrorUtil.handleError(error);
        AppSnackbar.showError(message: errorMessage.value);
      } catch (e) {
        pageStatus.value = Status.error;
        errorMessage.value = e.toString();
        AppSnackbar.showError(message: errorMessage.value);
      }
    } else {
      pageStatus.value = Status.error;
      errorMessage.value = 'check_connection'.tr;
      AppSnackbar.showError(message: 'check_connection'.tr);
    }
  }

  Future<void> refreshInboxes() => pagination.refresh();
}

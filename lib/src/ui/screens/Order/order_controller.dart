// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../../configs/api_response.dart';
import '../../../configs/app_enums.dart';
import '../../../data/models/Home/order_details_model.dart';
import '../../../data/models/Home/order_model.dart' as api;
import '../../../data/repository.dart';
import '../../../routes/routes_names.dart';
import '../../../utils/api_result.dart';
import '../../../utils/app_snackbar.dart';
import '../../../utils/dio_error_util.dart';
import '../../../utils/pagination_controller.dart';
import 'extensions/order_status_extension.dart';
import 'models/order_model.dart';

class OrderController extends GetxController {
  // ── Tab ──
  final selectedTab = 0.obs; // 0 = الحالية, 1 = السابقة

  // ── Expand/collapse state ──
  final expandedOrders = <String, bool>{}.obs;

  // ── Per‑order detail cache ──
  final orderDetails =
      <int, Rx<OrderDetail?>>{}.obs; // key = numeric API id
  final orderDetailsLoading =
      <int, RxBool>{}.obs; // loading per order

  // ── Dependencies ──
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  // ── Pagination (one per tab) ──
  late final activePagination = PaginationController<api.OrderItem>(
    perPage: 10,
    fetcher: (page, {query}) async {
      final res = await repository.getMyOrders('now', page: page);
      if (!res.isSuccess) {
        throw ApiException(res.message.isNotEmpty ? res.message : 'خطأ');
      }
      return PaginatedResult(
        data: res.data.orders,
        total: res.data.pagination.total,
        page: res.data.pagination.currentPage,
        perPage: res.data.pagination.perPage,
      );
    },
  );

  late final pastPagination = PaginationController<api.OrderItem>(
    perPage: 10,
    fetcher: (page, {query}) async {
      final res = await repository.getMyOrders('prev', page: page);
      if (!res.isSuccess) {
        throw ApiException(res.message.isNotEmpty ? res.message : 'خطأ');
      }
      return PaginatedResult(
        data: res.data.orders,
        total: res.data.pagination.total,
        page: res.data.pagination.currentPage,
        perPage: res.data.pagination.perPage,
      );
    },
  );

  PaginationController<api.OrderItem> get _activePagination =>
      selectedTab.value == 0 ? activePagination : pastPagination;

  // ── Page-level status ──
  final Rx<Status> pageStatus = Status.init.obs;
  final RxString errorMessage = ''.obs;

  // ── Computed UI lists ──
  List<OrderModel> get activeOrders =>
      activePagination.items.map(_mapToUi).toList();

  List<OrderModel> get pastOrders =>
      pastPagination.items.map(_mapToUi).toList();

  // ── Tab ──
  void changeTab(int index) => selectedTab.value = index;

  // ── Expand/collapse ──
  void toggleOrderExpand(OrderModel order) {
    final key = order.orderId;
    final wasExpanded = expandedOrders[key] ?? false;
    if (wasExpanded) {
      expandedOrders[key] = false;
    } else {
      expandedOrders[key] = true;
      // Fetch details if not already loaded
      if (!orderDetails.containsKey(order.apiId)) {
        _fetchOrderDetails(order.apiId);
      }
    }
    expandedOrders.refresh();
  }

  bool isOrderExpanded(String orderId) => expandedOrders[orderId] ?? false;

  /// Returns the cached detail for an order (or null if not yet fetched).
  OrderDetail? detailFor(int apiId) => orderDetails[apiId]?.value;

  /// Returns whether details are still loading for an order.
  bool isDetailLoading(int apiId) =>
      orderDetailsLoading[apiId]?.value ?? false;

  void retryOrderDetails(int apiId) => _fetchOrderDetails(apiId);

  // ── Fetch single order detail ──
  Future<void> _fetchOrderDetails(int id) async {
    orderDetailsLoading[id] = true.obs;
    try {
      final res = await repository.getDetailedOrder(id: id);
      if (!res.isSuccess || res.data == null) {
        throw ApiException(
          res.message.isNotEmpty ? res.message : 'تعذر تحميل التفاصيل',
        );
      }
      orderDetails[id] = Rx<OrderDetail?>(res.data!.order);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
      orderDetails[id] = Rx<OrderDetail?>(null);
    } on DioException catch (error) {
      log(error.response?.data?.toString() ?? error.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(error));
      orderDetails[id] = Rx<OrderDetail?>(null);
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
      orderDetails[id] = Rx<OrderDetail?>(null);
    } finally {
      orderDetailsLoading[id]?.value = false;
    }
  }

  // ── Lifecycle ──
  @override
  void onInit() {
    super.onInit();
    _loadBothTabs();
  }

  @override
  void onClose() {
    activePagination.dispose();
    pastPagination.dispose();
    super.onClose();
  }

  // ── API ──
  Future<void> _loadBothTabs() async {
    pageStatus.value = Status.loading;
    if (await connectionChecker.hasConnection) {
      try {
        await Future.wait([
          activePagination.loadInitial(),
          pastPagination.loadInitial(),
        ]);
        pageStatus.value = Status.completed;
      } on ApiException catch (e) {
        pageStatus.value = Status.error;
        errorMessage.value = e.message;
        AppSnackbar.showError(message: e.message);
      } on DioException catch (error) {
        log(error.response?.data?.toString() ?? error.toString());
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

  Future<void> refreshCurrentTab() => _activePagination.refresh();

  Future<void> _refreshAllOrders({int? clearDetailId}) async {
    if (clearDetailId != null) {
      orderDetails.remove(clearDetailId);
    }
    await Future.wait([
      activePagination.refresh(),
      pastPagination.refresh(),
    ]);
  }

  /// Opens payment screen for orders awaiting client payment.
  Future<void> payPendingOrder(int apiId) async {
    final detail = detailFor(apiId);
    await Get.toNamed(
      AppRoutesNames.payment,
      arguments: {
        'order_id': apiId,
        if (detail != null) 'order': detail.toPaymentArgsMap(),
      },
    );
    await _refreshAllOrders(clearDetailId: apiId);
  }

  Future<void> cancelOrder(int apiId) async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.cancelOrder(apiId);
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم إلغاء الطلب',
      );
      await _refreshAllOrders(clearDetailId: apiId);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  Future<void> rateOrder(
    int apiId, {
    required double rate,
    String? comment,
  }) async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final body = <String, dynamic>{'rate': rate};
      if (comment != null && comment.trim().isNotEmpty) {
        body['comment'] = comment.trim();
      }
      final res = await repository.rateOrder(apiId, data: body);
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم تقييم الطلب',
      );
      await _refreshAllOrders(clearDetailId: apiId);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void openOrderChat(int apiId) {
    Get.toNamed(AppRoutesNames.orderChat, arguments: apiId);
  }

  // ── Mapping: API OrderItem → UI OrderModel ──
  static OrderModel _mapToUi(api.OrderItem item) {
    final status = _mapApiStatus(item.status.value);
    return OrderModel(
      apiId: item.id,
      orderId: '#${item.id}',
      dateTime: item.date,
      restaurantName: item.market.name,
      restaurantAddress: item.market.locationTitle,
      totalPrice: double.tryParse(item.grandTotal) ?? 0.0,
      currentStep: _statusToStep(status),
      itemImageUrl: item.market.mainImage,
      restaurantLogoUrl: item.market.mainImage,
      status: status,
    );
  }

  /// Maps API status strings → [OrderStatus].
  static OrderStatus _mapApiStatus(String raw) {
    switch (raw.toLowerCase()) {
      case AppEnums.orderWaitingPayment:
      case 'waiting_client_payment':
        return OrderStatus.waitingPayment;
      case 'initiated':
      case 'new':
      case 'new_order':
        return OrderStatus.newOrder;
      case 'in_preparation':
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready_for_collection':
      case 'dispatched':
      case 'delivering':
        return OrderStatus.delivering;
      case 'delivered':
        return OrderStatus.delivered;
      case 'canceled':
      case 'cancelled':
      case 'rejected':
      case 'failed':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.newOrder;
    }
  }

  /// Converts [OrderStatus] to a step index (0-3).
  static int _statusToStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.waitingPayment:
      case OrderStatus.newOrder:
        return 0;
      case OrderStatus.preparing:
        return 1;
      case OrderStatus.delivering:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
        return 0;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/api_response.dart';

// ────────────────────────────────────────────────────────────
//  PaginatedResult – standardized paginated API envelope
// ────────────────────────────────────────────────────────────

/// Returned by every [PaginationController.fetcher] call.
/// The controller uses [hasMore] internally to decide whether
/// more pages exist.
class PaginatedResult<T> {
  /// Items returned for the current page.
  final List<T> data;

  /// Total items across all pages (from the API).
  final int total;

  /// The page just fetched (1‑based).
  final int page;

  /// Number of items requested per page.
  final int perPage;

  const PaginatedResult({
    required this.data,
    required this.total,
    required this.page,
    required this.perPage,
  });

  /// `true` when more pages remain.
  bool get hasMore => (page * perPage) < total;

  /// Convenience: whether this result carries any items.
  bool get isEmpty => data.isEmpty;
  bool get isNotEmpty => data.isNotEmpty;
}

// ────────────────────────────────────────────────────────────
//  PaginationController<T>
// ────────────────────────────────────────────────────────────

/// A **standalone, composable** pagination manager for any type [T].
///
/// It owns its own reactive state (`items`, loading flags, …) and an
/// internal [ScrollController] that automatically triggers load‑more
/// when the user scrolls near the bottom.
///
/// ### Usage inside any GetX controller
/// ```dart
/// late final productsPagination = PaginationController<Product>(
///   fetcher: (page, {query}) async {
///     final res = await repository.getProducts(page: page, search: query);
///     return PaginatedResult(
///       data: res.data.products,
///       total: res.data.total,
///       page: res.data.page,
///       perPage: _pageLimit,
///     );
///   },
///   perPage: 10,
/// );
///
/// // In onInit():
/// productsPagination.loadInitial();
///
/// // In onClose():
/// productsPagination.dispose();
/// ```
class PaginationController<T> {
  // ── constructor ──

  PaginationController({required this.fetcher, this.perPage = 10}) {
    _scrollCtrl.addListener(_onScroll);
  }

  // ── reactive state ──

  /// Accumulated items across all loaded pages.
  final RxList<T> items = <T>[].obs;

  /// Current page number (starts at 1).
  final RxInt currentPage = 1.obs;

  /// `true` while the *initial* fetch is in progress.
  final RxBool isLoading = false.obs;

  /// `true` while a *load‑more* fetch is in progress.
  final RxBool isLoadingMore = false.obs;

  /// `false` when the last page has been reached.
  final RxBool hasMore = true.obs;

  /// Current status for UI state rendering.
  final Rx<Status> status = Status.init.obs;

  /// Human‑readable error when [status] is [Status.error].
  final RxString errorMessage = ''.obs;

  /// Items per page.
  final int perPage;

  /// The fetch function provided by the consumer.
  ///
  /// Must return a [PaginatedResult<T>].  The controller takes care of
  /// everything else (accumulation, has‑more detection, error handling).
  final Future<PaginatedResult<T>> Function(int page, {String? query}) fetcher;

  // ── scroll controller (internal – used by the screen's ListView) ──

  final ScrollController _scrollCtrl = ScrollController();

  /// Attach this to your `ListView.builder`'s `controller` property.
  ScrollController get scrollController => _scrollCtrl;

  // ── private state ──

  static const double _loadMoreThreshold = 200;
  String? _currentQuery;

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    final maxScroll = _scrollCtrl.position.maxScrollExtent;
    final currentScroll = _scrollCtrl.position.pixels;
    if (currentScroll >= maxScroll - _loadMoreThreshold) {
      loadMore();
    }
  }

  // ── public API ──

  /// Fetches page 1, optionally with a [query].
  /// **Replaces** all accumulated items.
  Future<void> loadInitial({String? query}) async {
    _currentQuery = query;
    currentPage.value = 1;
    hasMore.value = true;
    isLoading.value = true;
    status.value = Status.loading;
    errorMessage.value = '';

    try {
      final result = await fetcher(1, query: query);
      items.assignAll(result.data);
      currentPage.value = 1;
      hasMore.value = result.hasMore;
      status.value = result.isNotEmpty ? Status.completed : Status.init;
    } catch (e) {
      items.clear();
      hasMore.value = false;
      status.value = Status.error;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Loads the next page and **appends** its items.
  /// Safe to call multiple times – guarded by [isLoadingMore] and [hasMore].
  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    final nextPage = currentPage.value + 1;

    try {
      final result = await fetcher(nextPage, query: _currentQuery);
      items.addAll(result.data);
      currentPage.value = nextPage;
      hasMore.value = result.hasMore;
    } catch (_) {
      // Silently ignore load‑more failures – don't disrupt the UI.
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Refreshes from page 1, keeping the current search query (if any).
  Future<void> refresh() => loadInitial(query: _currentQuery);

  /// Shortcut: performs a new search (resets to page 1).
  Future<void> search(String query) => loadInitial(query: query);

  /// Clears all items and resets state.
  void clear() {
    items.clear();
    currentPage.value = 1;
    hasMore.value = true;
    isLoading.value = false;
    isLoadingMore.value = false;
    status.value = Status.init;
    errorMessage.value = '';
    _currentQuery = null;
  }

  /// Must be called from the owning controller's `onClose()`.
  void dispose() {
    _scrollCtrl.dispose();
  }
}

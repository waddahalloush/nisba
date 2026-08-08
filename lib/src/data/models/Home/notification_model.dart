
import 'home_model.dart';

// ---------------------------------------------------------------------------
// Single Notification
// ---------------------------------------------------------------------------
class NotificationItem {
  final int id;
  final String title;
  final String message;
  final String? image;
  final EnumValue notificationType;
  final int? typeId;
  final EnumValue notificationStatus;
  final String createdAt;
  final int isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    this.image,
    required this.notificationType,
    this.typeId,
    required this.notificationStatus,
    required this.createdAt,
    required this.isRead,
  });

  /// Convenience getter: `true` when the notification has been read.
  bool get read => isRead == 1;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        id: json['id'] as int,
        title: json['title'] as String,
        message: json['message'] as String,
        image: json['image'] as String?,
        notificationType: EnumValue.fromJson(
          json['notification_type'] as Map<String, dynamic>,
        ),
        typeId: json['type_id'] as int?,
        notificationStatus: EnumValue.fromJson(
          json['notification_status'] as Map<String, dynamic>,
        ),
        createdAt: json['created_at'] as String,
        isRead: json['is_read'] as int,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'image': image,
    'notification_type': notificationType.toJson(),
    'type_id': typeId,
    'notification_status': notificationStatus.toJson(),
    'created_at': createdAt,
    'is_read': isRead,
  };
}

// ---------------------------------------------------------------------------
// Pagination
// ---------------------------------------------------------------------------
class Pagination {
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final String? nextPageUrl;
  final String? prevPageUrl;

  const Pagination({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
    count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
    perPage: int.tryParse(json['per_page']?.toString() ?? '') ?? 10,
    currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 1,
    totalPages: int.tryParse(json['total_pages']?.toString() ?? '') ?? 1,
    nextPageUrl: json['next_page_url']?.toString(),
    prevPageUrl: json['prev_page_url']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'total': total,
    'count': count,
    'per_page': perPage,
    'current_page': currentPage,
    'total_pages': totalPages,
    'next_page_url': nextPageUrl,
    'prev_page_url': prevPageUrl,
  };
}

// ---------------------------------------------------------------------------
// NotificationsData — the `data` node
// ---------------------------------------------------------------------------
class NotificationsData {
  final List<NotificationItem> notifications;
  final Pagination pagination;

  const NotificationsData({
    required this.notifications,
    required this.pagination,
  });

  factory NotificationsData.fromJson(Map<String, dynamic> json) =>
      NotificationsData(
        notifications: (json['notifications'] as List<dynamic>)
            .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: Pagination.fromJson(
          json['pagination'] as Map<String, dynamic>,
        ),
      );
}

// ---------------------------------------------------------------------------
// NotificationResponse — top-level API wrapper
// ---------------------------------------------------------------------------
class NotificationResponse {
  final String status;
  final String message;
  final NotificationsData data;

  const NotificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        status: json['status'] as String,
        message: json['message'] as String,
        data: NotificationsData.fromJson(json['data'] as Map<String, dynamic>),
      );
}

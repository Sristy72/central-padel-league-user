import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/model/notification_dummy_model.dart';
import '../../domain/repo/notification_repo.dart';

class NotificationController extends BaseController {
  final NotificationRepo _notificationRepo;
  final AuthStorageService _authStorageService;
  
  var notifications = <NotificationModel>[].obs;
  var isLoadingNotifications = false.obs;
  var isEmpty = false.obs;

  NotificationController({
    required NotificationRepo notificationRepo,
    required AuthStorageService authStorageService,
  })  : _notificationRepo = notificationRepo,
        _authStorageService = authStorageService;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoadingNotifications.value = true;
      isEmpty.value = false;
      
      // Get userId from storage or use default
      final userId = await _authStorageService.getUserId() ?? '68d117a5d487a29db7269e1d';
      
      final result = await _notificationRepo.getNotificationsByUserId(userId);
      
      result.fold(
        (failure) {
          isLoadingNotifications.value = false;
          isEmpty.value = true;
          notifications.value = [];
          Get.snackbar(
            'Error',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        (success) {
          final notificationList = success.data;
          if (notificationList.isEmpty) {
            isEmpty.value = true;
            notifications.value = [];
          } else {
            isEmpty.value = false;
            notifications.value = notificationList.map((apiNotification) {
              return NotificationModel(
                title: apiNotification.title,
                message: apiNotification.message,
                timeAgo: _formatTimeAgo(apiNotification.createdAt),
                isUnread: !apiNotification.isRead,
              );
            }).toList();
          }
          isLoadingNotifications.value = false;
        },
      );
    } catch (e) {
      isLoadingNotifications.value = false;
      isEmpty.value = true;
      notifications.value = [];
    }
  }
  
  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void markAllAsRead() {
    notifications.value = notifications.map((n) {
      return NotificationModel(
        title: n.title,
        message: n.message,
        timeAgo: n.timeAgo,
        isUnread: false,
      );
    }).toList();
  }
}

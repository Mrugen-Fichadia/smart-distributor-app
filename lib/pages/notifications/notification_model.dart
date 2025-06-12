// ------------ Notification Model -------------

class NotificationItem {
  final String id;
  final String message;
  final String description;
  final String timeAgo;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.message,
    required this.description,
    required this.timeAgo,
    this.isRead = false,
  });
}

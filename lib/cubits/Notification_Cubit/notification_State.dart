class NotificationState {
  final bool isLoading;
  final List<dynamic> notifications;
  final String error;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.error = '',
  });

  NotificationState copyWith({
    bool? isLoading,
    List<dynamic>? notifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error ?? this.error,
    );
  }
  int get unreadCount {
    return notifications.where((notif) => !(notif['isRead'] ?? true)).length;
  }
}
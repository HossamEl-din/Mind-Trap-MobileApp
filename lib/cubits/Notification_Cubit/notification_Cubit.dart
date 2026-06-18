import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:grad/cubits/Notification_Cubit/notification_State.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationCubit extends Cubit<NotificationState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://hossammourad-001-site1.ltempurl.com'));

  NotificationCubit() : super(const NotificationState()) {
    fetchNotifications();
  }

  // 1. جلب الإشعارات
  Future<void> fetchNotifications() async {
    emit(state.copyWith(isLoading: true, error: ''));
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await _dio.get(
        '/api/Notifications',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        emit(state.copyWith(isLoading: false, notifications: response.data));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load notifications.'));
      print("Fetch Notifications Error: $e");
    }
  }

 
  Future<void> markAsRead(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      await _dio.put(
        '/api/Notifications/$id/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // تحديث اللستة محلياً عشان الـ UI يتغير فوراً بدل ما نعمل Fetch من الأول
      final updatedNotifications = state.notifications.map((notif) {
        if (notif['id'] == id) {
          // بنعمل نسخة جديدة من الماب ونغير isRead لـ true
          return {...notif, 'isRead': true}; 
        }
        return notif;
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));

    } catch (e) {
      print("Mark as Read Error: $e");
    }
  }
}